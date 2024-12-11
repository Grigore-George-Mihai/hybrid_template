# frozen_string_literal: true

ActiveAdmin.register User do
  permit_params :first_name, :last_name, :email, :role, :password, :password_confirmation

  filter :first_name_cont, as: :string
  filter :last_name_cont, as: :string
  filter :email_cont, as: :string
  filter :role, as: :select, collection: User.roles.keys, input_html: { class: "select2" }
  filter :created_at

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :email
    column :role
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :first_name
      row :last_name
      row :email
      row :role
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs "User Details" do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :role, as: :select, collection: User.roles.keys, input_html: { class: "select2" }
      f.input :password, hint: (I18n.t("active_admin.hints.password") unless f.object.new_record?)
      f.input :password_confirmation, hint: (I18n.t("active_admin.hints.password") unless f.object.new_record?)
    end
    f.actions
  end
end
