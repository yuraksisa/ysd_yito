require 'ysd-plugins' unless defined?Plugins::ModelAspect
require 'ysd_md_location' unless defined?FieldSet::Location
require 'ysd_md_photo_gallery' unless defined?FieldSet::Photo
require 'ysd_md_cms' unless defined?ContentManagerSystem::Content
require 'ysd_md_profile' unless defined?Users::Profile
require 'ysd_md_attachment' unless defined?Model::Attachment
require 'fieldsets/ysd_md_commentable'
require 'fieldsets/ysd_md_fieldset_content_place'

#
# Configure the aspects which can be applied to the models
#

# Aspects applicable to ContentManagerSystem::Term
Plugins::ModelAspect.aspect_applicable(FieldSet::Photo, ContentManagerSystem::Term)

# Aspects applicable to ContentManagerSystem::Content
Plugins::ModelAspect.aspect_applicable(FieldSet::Album, ContentManagerSystem::Content)
Plugins::ModelAspect.aspect_applicable(FieldSet::Photo, ContentManagerSystem::Content)
Plugins::ModelAspect.aspect_applicable(FieldSet::Contact, ContentManagerSystem::Content)
Plugins::ModelAspect.aspect_applicable(FieldSet::Location, ContentManagerSystem::Content)
Plugins::ModelAspect.aspect_applicable(FieldSet::Event, ContentManagerSystem::Content)
Plugins::ModelAspect.aspect_applicable(Model::Attachment, ContentManagerSystem::Content)
Plugins::ModelAspect.aspect_applicable(ContentManagerSystem::FieldSet::Commentable, ContentManagerSystem::Content)
Plugins::ModelAspect.aspect_applicable(ContentManagerSystem::FieldSet::ContentPlace, ContentManagerSystem::Content)
Plugins::ModelAspect.aspect_applicable(Model::Translatable, ContentManagerSystem::Content)

# Aspects applicable to Users::Profile
Plugins::ModelAspect.aspect_applicable(FieldSet::EducationEmployment, Users::Profile)
Plugins::ModelAspect.aspect_applicable(FieldSet::Hobbies, Users::Profile)
Plugins::ModelAspect.aspect_applicable(FieldSet::Photo, Users::Profile)

#
# Apply the applicable aspects
#

Plugins::ModelAspect.apply   