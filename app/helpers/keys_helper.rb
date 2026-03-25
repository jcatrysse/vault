module KeysHelper
  include Redmine::Export::PDF
  include Redmine::Export::PDF::IssuesPdfHelper

  def key_types
    [[t('activerecord.models.password'),'Vault::Password'], [t('activerecord.models.sftp'),'Vault::Sftp'], [t('activerecord.models.key_file'),'Vault::KeyFile']]
  end

  def keys_to_pdf(keys, project, query)
    pdf = ITCPDF.new(current_language, "L")
    title_prefix = project.present? ? project.to_s : t('label_module')
    title = "#{title_prefix} #{t('export.pdf.title')}"
    pdf.set_title(title)
    pdf.alias_nb_pages
    pdf.footer_date = format_date(Date.today)
    pdf.set_auto_page_break(false)
    pdf.add_page("L")

    # Landscape A4 = 210 x 297 mm
    page_height   = pdf.get_page_height # 210
    page_width    = pdf.get_page_width  # 297
    left_margin   = pdf.get_original_margins['left'] # 10
    right_margin  = pdf.get_original_margins['right'] # 10
    bottom_margin = pdf.get_footer_margin
    row_height    = 5

    # column widths
    table_width = page_width - right_margin - left_margin
    columns = Vault::Key.column_names + ['tags']
    column_width = table_width / columns.count

    # title
    pdf.SetFontStyle('B',11)
    pdf.RDMCell(190,10, title)
    pdf.ln

    columns.each_with_index do |column, index|
      pdf.RDMMultiCell(column_width, row_height, pdf_safe_text(column), 1, "", 0, index == columns.count - 1 ? 1 : 0)
    end

    pdf.SetFontStyle('',8)

    keys.each { |key|
      base_y     = pdf.get_y

      columns.each_with_index do |column, index|
        value = if column == 'tags'
                  key.tags.map(&:name).join(', ')
                else
                  key.read_attribute(column)
                end

        pdf.RDMMultiCell(column_width, row_height, pdf_safe_text(value), 1, "", 0, index == columns.count - 1 ? 1 : 0)
      end

      max_height = 6*row_height
      space_left = page_height - base_y - bottom_margin

      if max_height > space_left
        pdf.add_page("L")
        base_y = pdf.get_y
      end

    }

    pdf.output
  end

  private

  def pdf_safe_text(value)
    text = value.to_s
    text = '-' if text.blank?
    text.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?')
  end

end
