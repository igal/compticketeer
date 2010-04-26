class TicketKind < ActiveRecord::Base
  named_scope :ordered, :order => "lower(title) asc"

  has_many :tickets, :dependent => :destroy

  validates_presence_of :title
  validates_length_of :title, :within => 1..128
  validates_presence_of :prefix
  validates_length_of :prefix, :within => 1..20
  validates_presence_of :template
  validates_length_of :template, :minimum => 1

  # Override title to automatically set prefix if needed.
  def title=(value)
    super(value)
    self.set_prefix
    return self.title
  end

  # Set the prefix if one isn't set.
  def set_prefix
    if self.prefix.nil? && self.title.present?
      self.prefix = self.title.to_s.gsub(/\W/, '').downcase
    end
  end
end
