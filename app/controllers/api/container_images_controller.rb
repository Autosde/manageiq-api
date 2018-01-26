module Api
  class ContainerImagesController < BaseController
    def scan_resource(type, image_id, _payload)
      raise BadRequestError, "Must specify an id for starting a #{type} resource" unless image_id
      api_action(type, image_id, :skip_href => true) do |klass|
        image = resource_search(image_id, type, klass)
        begin
          task_id = image.scan
          desc = if task_id.present?
                   "#{container_image_ident(image)} scanning"
                 else
                   "#{container_image_ident(image)} failed to start scanning"
                 end
          action_result(task_id.present?, desc).merge(:task_id => task_id)
        rescue => err
          action_result(false, err.to_s)
        end
      end
    end

    private

    def container_image_ident(image)
      "ContainerImage id:#{image.id} name:'#{image.name}'"
    end
  end
end
