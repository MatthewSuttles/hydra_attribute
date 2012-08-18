Feature: new entity
  Given new entity should respond to hydra attributes which are saved in hydra_attributes table

  When hydra attribute was created with white_list flag
  Then it should be allowed through mass-assignment for new entity

  When hydra_set_id was passed to new entity
  Then entity should respond only to hydra attributes which was added to this hydra set

  Scenario Outline: models should respond to hydra attributes
    Given create hydra attributes for "Product" with role "admin" as "hashes":
      | name  | backend_type | white_list      |
      | code  | string       | [boolean:true]  |
      | price | float        | [boolean:false] |
    Then model "<model>" <action> respond to "<attributes>"

    Scenarios: hydra attributes
      | model   | action | attributes             |
      | Product | should | code                   |
      | Product | should | code=                  |
      | Product | should | code?                  |
      | Product | should | code_before_type_cast  |
      | Product | should | code_changed?          |
      | Product | should | code_change            |
      | Product | should | code_will_change!      |
      | Product | should | code_was               |
      | Product | should | reset_code!            |
      | Product | should | price                  |
      | Product | should | price=                 |
      | Product | should | price?                 |
      | Product | should | price_before_type_cast |
      | Product | should | price_changed?         |
      | Product | should | price_change           |
      | Product | should | price_will_change!     |
      | Product | should | price_was              |
      | Product | should | reset_price!           |

  Scenario: model should have appropriate hydra attributes in white list
    Given create hydra attributes for "Product" with role "admin" as "hashes":
      | name  | backend_type | white_list      |
      | code  | string       | [boolean:true]  |
      | price | float        | [boolean:false] |
    # imitate initialization model class with already created hydra attributes
    When redefine "Product" class to use hydra attributes
    Then class "Product" should have "code" in white list
    And class "Product" should not have "price" in white list

  Scenario: model should respond to hydra attributes which are in hydra set if hydra_set_id is passed
    Given create hydra sets for "Product" as "hashes":
      | name    |
      | Default |
      | General |
    And create hydra attributes for "Product" with role "admin" as "hashes":
      | name  | backend_type | white_list     |
      | code  | string       | [boolean:true] |
      | title | string       | [boolean:true] |
      | price | float        | [boolean:true] |
      | total | integer      | [boolean:true] |
    And add "Product" hydra attributes to hydra set:
      | hydra attribute name | hydra set name          |
      | code                 | [array:Default]         |
      | title                | [array:Default,General] |
      | price                | [array:General]         |

    When build "Product" model:
      | hydra_set_id | [string:[eval:Product.hydra_sets.find_by_name('Default').id]] |
    Then model should respond to "code"
    And model should respond to "title"
    And model should not respond to "price"
    And model should not respond to "total"

    When build "Product" model:
      | hydra_set_id | [string:[eval:Product.hydra_sets.find_by_name('General').id]] |
    Then model should not respond to "code"
    And model should respond to "title"
    And model should respond to "price"
    And model should not respond to "total"

    When build "Product" model
    Then model should respond to "code"
    And model should respond to "title"
    And model should respond to "price"
    And model should respond to "total"