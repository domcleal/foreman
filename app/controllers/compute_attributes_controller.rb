class ComputeAttributesController < ApplicationController
  include Foreman::Controller::Parameters::ComputeAttribute

  def new
    @set = ComputeAttribute.new(:compute_profile_id => params[:compute_profile_id].to_i,
                                :compute_resource_id => params[:compute_resource_id].to_i)
  end

  def create
    @set = ComputeAttribute.new(compute_attribute_params)
    @set.vm_attrs = params[:compute_attribute][:vm_attrs] if params[:compute_attribute].has_key?(:vm_attrs)
    if @set.save
      process_success :success_redirect => request.referer || compute_profile_path(@set.compute_profile)
    else
      process_error :object => @set
    end
  end

  def edit
    @set = ComputeAttribute.find_by_id(params[:id])
  end

  def update
    @set = ComputeAttribute.find(params[:id])
    @set.attributes = compute_attribute_params
    @set.vm_attrs = params[:compute_attribute][:vm_attrs] if params[:compute_attribute].has_key?(:vm_attrs)
    if @set.save
      process_success :success_redirect => request.referer || compute_profile_path(@set.compute_profile)
    else
      process_error :object => @set
    end
  end
end
