module HydraAttribute
  # TODO add #build_entity and #create_entity methods
  class HydraSet

    # This error is raised when called method for attribute which doesn't exist in current hydra set
    #
    # @example
    #   Product.hydra_attributes.create(name: 'price', backend_type: 'float')
    #   Product.hydra_attributes.create(name: 'title', backend_type: 'string')
    #
    #   hydra_set = Product.hydra_sets.create(name: 'Default')
    #   hydra_set.hydra_attributes = [Product.hydra_attribute('title')]
    #
    #   product = Product.new(hydra_set_id: hydra_set.id)
    #   product.title = 'Toy' # ok
    #   product.price = 2.50  # raise HydraAttribute::HydraSet::MissingAttributeInHydraSetError
    class MissingAttributeInHydraSetError < NoMethodError
    end

    include ::HydraAttribute::Model

    define_cached_singleton_method :all_by_entity_type, cache_key: :entity_type, cache_value: :self, cache_key_cast: :to_s

    validates :entity_type, presence: true # TODO add match validation with its hydra_attributes.entity_type
    validates :name,        presence: true, unique: { scope: :entity_type }

    has_many :hydra_attributes, through: :hydra_attribute_set, copy_attribute: :entity_type

    def has_hydra_attribute_id?(hydra_attribute_id)
      HydraAttributeSet.has_hydra_attribute_id_in_hydra_set_id?(hydra_attribute_id, id)
    end

  end
end