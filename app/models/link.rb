class Link < ActiveRecord::Base
  include Messageable
  before_validation :set_shortcode, unless: :shortcode?
  validates :url, presence: true
  validate :shortcode_correctness
  SHORT_FORMAT = /^[0-9a-zA-Z_]{4,}$/

  %i[
    FormatError
    DuplicateError
  ].each {|exception| self.const_set(exception, Class.new(ActiveRecord::RecordInvalid))}

  def self.new_shortcode
    loop do
      shortcode = ShortcodeGenerator.generate(6)
      return shortcode unless self.find_by_shortcode(shortcode)
    end
  end

  def increment_redirect_count!
    self.redirect_count += 1; save
  end

  def stats
    stats = {
        start_date: created_at.iso8601,
        last_seen_date: updated_at.iso8601
    }

    stats.merge!(redirect_count: redirect_count) if redirect_count > 0
    stats
  end

  private
  def shortcode_correctness
    raise Link::FormatError.new, format_error_message unless SHORT_FORMAT =~ shortcode
    raise Link::DuplicateError.new, duplicate_error_message unless shortcode_is_unique?
  end

  def set_shortcode
    self.shortcode = self.class.new_shortcode
  end

  def shortcode_is_unique?
    instance = self.class.find_by_shortcode(shortcode)
    instance.nil? || instance === self
  end
end
