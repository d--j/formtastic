# coding: utf-8
require File.dirname(__FILE__) + '/spec_helper'

describe 'wai aria' do

  include FormtasticSpecHelper

  before do
    @output_buffer = ''
    mock_everything
    @title_errors = ['must not be blank', 'must be longer than 10 characters', 'must be awesome']
    @errors = mock('errors')
    @new_post.stub!(:errors).and_return(@errors)
    @errors.stub!(:[]).with(:title).and_return(@title_errors)
    @errors.stub!(:[]).with(:body).and_return(nil)
  end

  describe 'disabled' do
    
    before do
      ::Formtastic::SemanticFormBuilder.wai_aria_enabled = false
      semantic_form_for(@new_post) do |builder|
        concat(builder.input(:title, :as => :text, :hint => 'This is a hint', :required => true))
      end
    end
    
    it 'should not have WAI ARIA markup' do
      output_buffer.should_not have_tag("form li input#post_title[@aria-describedby]")
      output_buffer.should_not have_tag('form li input#post_title[@aria-required]')
      output_buffer.should_not have_tag('form li input#post_title[@aria-invalid]')
    end

  end
  
  describe 'enabled' do
    before do
      ::Formtastic::SemanticFormBuilder.wai_aria_enabled = true
      semantic_form_for(@new_post) do |builder|
        concat(builder.input(:title, :as => :string, :hint => 'This is a hint', :required => true))
        concat(builder.input(:body, :as => :text, :required => false))
      end
    end
    
    it 'should have WAI ARIA markup' do
      output_buffer.should have_tag('form li input#post_title[@aria-describedby="post_title_inline_hint"]')
      output_buffer.should have_tag('form li input#post_title[@aria-required="true"]')
      output_buffer.should have_tag('form li input#post_title[@aria-invalid="true"]')
      output_buffer.should_not have_tag('form li textarea#post_body[@aria-describedby]')
      output_buffer.should have_tag('form li textarea#post_body[@aria-required="false"]')
    end
  end

end

