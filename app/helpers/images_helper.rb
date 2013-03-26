module ImagesHelper
  def image_field f
    if @compute_resource.capabilities.include?(:image)
      images = @compute_resource.available_images
      if images.any?
        return select_f(f, :uuid, images.to_a.sort! { |a, b| a.name.downcase <=> b.name.downcase }, :id, :name, {}, :label => _('Image'))
      end
    else
      text_f f, :uuid, :label => _("Image ID"), :help_inline => _("Image ID as provided by the compute resource, e.g. ami-..")
    end
  end
end
