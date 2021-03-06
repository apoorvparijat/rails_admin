require 'rails_admin/config/model'

module RailsAdmin
  module Config
    class LazyModel
      def initialize(entity)
        @entity = entity
      end

      def method_missing(method, *args, &block)
        if @block && not(@block_already_evaluated)
          @model ||= RailsAdmin::Config::Model.new(@entity)
          @model.instance_eval(&@block)
          @block_already_evaluated = true
        else
          @model ||= RailsAdmin::Config::Model.new(@entity)
        end
        @model.send(method, *args, &block)
      end

      def store(block)
        if @block # reset model to not eval twice
          @model = RailsAdmin::Config::Model.new(@entity)
          @block_already_evaluated = false
        end
        @block = block
      end
    end
  end
end