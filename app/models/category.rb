class Category < ApplicationRecord
  has_ancestry

  before_save :set_code
  
  def self.cluster
    where("ancestry ~ '^[0-9]+$'")
  end

  def self.master
    where(:ancestry => nil)
  end

  def is_cluster?
    ancestry.present? && /^[0-9]+$/.match?(ancestry)
  end

  def is_master?
    ancestry.blank?
  end

  private

  def sequence_to_string
    sprintf('%04d', @sequence)
  end

  def set_master_code
    @sequence = self.class.select(:id).where(:ancestry => nil).count + 1
    self.code = "CAT-#{sequence_to_string}" 
  end

  def set_cluster_code
    @sequence = self.class.select(:id).cluster.count + 1
    self.code = "CLU-#{sequence_to_string}"
  end

  def set_code
    set_master_code if self.is_master?
    set_cluster_code if self.is_cluster?
  end
end
