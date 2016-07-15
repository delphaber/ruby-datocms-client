require "json"
require "json_schema"
require_relative "./build_repo"

class BuildClient
  attr_reader :schema, :namespace, :blacklisted_resources

  def initialize(schema, namespace, blacklisted_resources)
    @namespace = namespace
    @blacklisted_resources = blacklisted_resources
    @schema = JsonSchema.parse!(JSON.parse(schema))
    @schema.expand_references!
  end

  def build
    schema.properties.each do |resource, resource_schema|
      if !blacklisted_resources.include?(resource) && resource_schema.links.any?
        BuildRepo.new(namespace, resource, resource_schema).build
      end
    end
  end
end
