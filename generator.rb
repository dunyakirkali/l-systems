require 'yaml'

class Generator
  attr_reader :config, :axiom

  def initialize(axiom)
    @axiom = axiom
    @config = YAML.load_file('rules.yml')
    @rules = config['rules']
  end

  def axiom_chars
    @axiom.chars.to_a
  end

  def generate
    next_step = ''
    for i in axiom_chars
      @rules.each do |rule|
        next_step << rule["output"] if i == rule["input"]
      end
    end
    @axiom = next_step
  end
end
