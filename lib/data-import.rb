
require 'yaml'
require 'progress'
require 'active_support/all'

require "data-import/version"
require 'data-import/runner'
require 'data-import/execution_plan'
require 'data-import/dsl'
require 'data-import/database'
require 'data-import/definition'
require 'data-import/importer'

# Monkeypatch for active support (see https://github.com/rails/rails/pull/2801)
class Time
  class << self
    def ===(other)
      super || (self == Time && other.is_a?(ActiveSupport::TimeWithZone))
    end
  end
end

module DataImport

  def self.run_config!(config_path, options = {})
    plan = DataImport::Dsl.evaluate_import_config(config_path)
    run_plan!(plan, options)
  end

  def self.run_plan!(plan, options = {})
    runner = Runner.new(plan)
    runner.run(options)
  end

end