module HydraAttribute
  module ActiveRecord
    module Scoping
      extend ActiveSupport::Concern

      module ClassMethods
        def scoped(options = nil)
          relation = super(options)
          relation.singleton_class.send :include, Relation
          relation
        end
      end
    end
  end
end