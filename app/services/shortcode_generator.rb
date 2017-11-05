class ShortcodeGenerator
  CHARSET = ['A'..'Z', 'a'..'z', 0..9].map(&:to_a).flatten.freeze

  def self.generate(len)
    CHARSET.sample(len).join
  end
end
