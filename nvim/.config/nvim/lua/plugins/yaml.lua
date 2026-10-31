return {
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'towolf/vim-helm' },
    init = function()
      vim.filetype.add({
        pattern = {
          ['.*/values[^/]*%.ya?ml'] = function(path)
            if vim.fs.root(path, 'Chart.yaml') then
              return 'yaml.helm-values'
            end
          end,
        },
      })
    end,
    opts = {
      servers = {
        yamlls = {
          -- Helm owns chart values files, avoiding duplicate YAML diagnostics.
          filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab' },
          settings = {
            yaml = {
              schemas = {
                -- Scope Kubernetes validation to manifest and GitOps directories.
                -- Elsewhere, select a schema with a yaml-language-server modeline.
                kubernetes = {
                  '**/k8s/**/*.yaml',
                  '**/k8s/**/*.yml',
                  '**/kubernetes/**/*.yaml',
                  '**/kubernetes/**/*.yml',
                  '**/manifests/**/*.yaml',
                  '**/manifests/**/*.yml',
                  '*.k8s.yaml',
                  '*.k8s.yml',
                  '**/homelab/apps/**/*.yaml',
                  '**/homelab/apps/**/*.yml',
                  '**/homelab/clusters/**/*.yaml',
                  '**/homelab/clusters/**/*.yml',
                  '**/homelab/controllers/**/*.yaml',
                  '**/homelab/controllers/**/*.yml',
                  '**/homelab/infrastructure/**/*.yaml',
                  '**/homelab/infrastructure/**/*.yml',
                  -- Kustomize configuration has its own SchemaStore schema.
                  '!**/kustomization.yaml',
                  '!**/kustomization.yml',
                },
              },
            },
          },
        },
        -- Helm starts its own YAML server for rendered templates and values.
        helm_ls = {},
      },
    },
  },
}
