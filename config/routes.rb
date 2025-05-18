# Plugin routes for GEOxyz Vault
# NOTE: We give Vault’s tag routes a dedicated path (“vault_tags”)
#       so they can never clash with the generic tag plugins.

resources :projects do
  # Key-related extras inside a project
  match 'keys/context_menu', to: 'keys#context_menu',
        as: :keys_context_menus, via: %i[get post]

  get   'key_files/:id/download', to: 'key_files#download', as: :download_key_file
  get   'keys/:id/copy',          to: 'keys#copy',          as: :copy_key

  # Full REST for keys within a project
  resources :keys

  # Vault-specific tags for a key
  resources :keys, only: [] do
    resources :vault_tags,                       # helper ⇒ project_key_vault_tags_path
              path:       'vault_tags',          # URL   ⇒ …/keys/:key_id/vault_tags
              controller: 'vault_tags',
              only:       %i[index create update destroy]
  end
end

# Cross-project overview of all keys
get 'keys/all', to: 'keys#all', as: :keys_all

# Vault settings (stand-alone resource)
resources :vault_settings do
  collection do
    get  :autocomplete_for_user
    post :backup,  to: 'vault_settings#backup'
    post :restore, to: 'vault_settings#restore'
    post :save,    to: 'vault_settings#save'
  end
end
