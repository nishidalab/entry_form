module ApplicationHelper
  # ページごとの完全なタイトルを返します．
  def full_title(page_title)
    base_title = "Nishida Lab."
    if page_title.empty?
      base_title
    else
      page_title + " - " + base_title
    end
  end

  # form_for の入力フィールド(text_field)となる HTML を返します。
  def form_text_field(form, attribute, label, size: 8, description: nil, example: nil, required: true, unit: nil)
    form_xxxx 'text_field', form, attribute, label, size: size, description: description, example: example, required: required, unit: unit
  end

  # form_for の入力フィールド(email_field)となる HTML を返します。
  def form_email_field(form, attribute, label, size: 8, description: nil, example: nil, required: true)
    form_xxxx 'email_field', form, attribute, label, size: size, description: description, example: example, required: required
  end

  # form_for の入力フィールド(password_field)となる HTML を返します。
  def form_password_field(form, attribute, label, size: 8, description: nil, example: nil, required: true)
    form_xxxx 'password_field', form, attribute, label, size: size, description: description, example: example, required: required
  end

  # form_for の入力フィールド(text_area)となる HTML を返します。
  def form_text_area(form, attribute, label, size: 8, description: nil, example: nil, required: true)
    form_xxxx 'text_area', form, attribute, label, size: size, description: description, example: example, required: required
  end

  # form_for の入力フィールド(select)となる HTML を返します。
  def form_select(form, attribute, label, options, selected: nil, size: 4, description: nil, example: nil, required: true)
    html_option = required ?
        { class: 'form-control validation', required: true } :
        { class: 'form-control' }
    "<div class='form-group'>".html_safe +
      form.label(attribute, label, class: 'col-sm-2 control-label') +
      "<div class='col-sm-#{size}'>".html_safe +
      form.select(attribute, options_for_select(options, selected: selected), { prompt: '選択してください' }, html_option) +
        (description ?
          "<span class='help-block'>#{description}</span>" : "").html_safe +
        (example ?
          "<span class='help-block'><span class='label label-default'>例</span>#{example}</span>" : "").html_safe +
      "</div>".html_safe +
    "</div>".html_safe
  end

  # form_for の入力フィールド(collection_select)となる HTML を返します。
  def form_collection_select(form, attribute, label, object_array, value, name, options, selected: nil, size: 4, description: nil, example: nil, required: true)
    html_option = required ?
        { class: 'form-control validation', required: true } :
        { class: 'form-control' }
    "<div class='form-group'>".html_safe +
      form.label(attribute, label, class: 'col-sm-2 control-label') +
      "<div class='col-sm-#{size}'>".html_safe +
      form.collection_select(attribute, object_array, value, name, options, html_option) +
        (description ?
          "<span class='help-block'>#{description}</span>" : "").html_safe +
        (example ?
          "<span class='help-block'><span class='label label-default'>例</span>#{example}</span>" : "").html_safe +
      "</div>".html_safe +
    "</div>".html_safe
  end

  # form_for の入力フィールド(年・月・日)となる HTML を返します。
  def form_date(form, attribute, label, start_year, end_year, size: 4, description: nil, example: nil, required: true)
    html_option = required ?
        { class: 'form-control bootstrap-date validation', required: true } :
        { class: 'form-control bootstrap-date' }
    "<div class='form-group'>".html_safe +
      form.label(attribute, label, class: 'col-sm-2 control-label') +
      "<div class='col-sm-#{size}'>".html_safe +
      (raw sprintf( form.date_select(attribute, { start_year: start_year, end_year: end_year, use_month_numbers: true,
                                                  prompt: '----', date_separator: '%s' }, html_option),
                    '年 ', '月 ') + '日') +
      (description ?
        "<span class='help-block'>#{description}</span>" : "").html_safe +
      (example ?
        "<span class='help-block'><span class='label label-default'>例</span>#{example}</span>" : "").html_safe +
      "</div>".html_safe +
    "</div>".html_safe
  end

  # form_for の入力フィールド(年・月・日 fromとto)となる HTML を返します。
  def form_date_fromto(form, attribute_from, attribute_to, label, start_year, end_year, size: 4, description: nil, example: nil, required: true)
    html_option = required ?
        { class: 'form-control bootstrap-date validation', required: true } :
        { class: 'form-control bootstrap-date' }
    "<div class='form-group'>".html_safe +
      form.label(attribute_from, label, class: 'col-sm-2 control-label') +
      "<div class='col-sm-#{size * 2}'>".html_safe +
      (raw sprintf( form.date_select(attribute_from, { start_year: start_year, end_year: end_year, use_month_numbers: true,
                                                  prompt: '----', date_separator: '%s' }, html_option),
                    '年 ', '月 ') + '日') + "〜" +
      (raw sprintf( form.date_select(attribute_to, { start_year: start_year, end_year: end_year, use_month_numbers: true,
                                                  prompt: '----', date_separator: '%s' }, html_option),
                    '年 ', '月 ') + '日') +
      (description ?
        "<span class='help-block'>#{description}</span>" : "").html_safe +
      (example ?
        "<span class='help-block'><span class='label label-default'>例</span>#{example}</span>" : "").html_safe +
      "</div>".html_safe +
    "</div>".html_safe
  end

  # form_for の submit ボタンとなる HTML を返します。
  def form_submit(form, label, size: 8, type: 'btn-primary')
    "<div class='col-sm-offset-2 col-sm-#{size}'>".html_safe +
      (form.submit label, class: "form-control btn #{type}") +
    "</div>".html_safe
  end

  # Bootstrap の Panel となる HTML を返します。
  def panel(type: 'primary', header: nil, body: nil, footer: nil)
    "<div class='panel panel-#{type}'>".html_safe +
      (header ?
        "<div class='panel-heading'>#{header}</div>" : "").html_safe +
      (body ?
          "<div class='panel-body'>#{body}</div>" : "").html_safe +
      (footer ?
          "<div class='panel-footer'>#{footer}</div>" : "").html_safe +
    "</div>".html_safe
  end

  # 子モデルのフォーム追加ボタン
  def link_to_add_field(name, f, association, options={})
    # association で渡されたシンボルから、対象のモデルを作る
    # @parent.children.build に対応する処理
    new_object = f.object.class.reflect_on_association(association).klass.new

    # JS側の配列のインデックス値。重複対策で後にミリ秒の値で置き換える
    id = new_object.object_id

    # f はビューから渡されたフォームオブジェクト
    # fields_for で f の子要素を作る
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_form", f: builder)
    end

    # ボタンの設置。classを指定してJSと連動、fields を渡しておいて、
    # ボタン押下時にこの要素(fields)をJavascript側で増やすようにする
    link_to(name, '#', class: "add_field", data: {id: id, fields: fields.gsub("\n","")})
  end

  #削除ボタン
  def link_to_remove_field(name, f, options={})
    # _destroy の hiddenフィールドと削除ボタンを設置
    f.hidden_field(:_destroy) + link_to(name, '#', class: "remove_field")
  end

  # form_tag の入力フィールド(text_area_tag)となる HTML を返します。
  def form_text_area_tag(name, label, size: 8, value: nil, description: nil, example: nil, required: true)
    form_xxxx_tag 'text_area_tag', name, label, size: size, value: value, description: description, example: example, required: required
  end

  private

    # form_xxxx (form_text_field や form_text_area) で呼び出されるメソッドです。
    def form_xxxx(xxxx, form, attribute, label, size: 8, description: nil, example: nil, required: true, unit: nil)
      html_option = required ?
          { class: 'form-control validation', required: true } :
          { class: 'form-control' }
      "<div class='form-group'>".html_safe +
        form.label(attribute, label, class: 'col-sm-2 control-label') +
        "<div class='col-sm-#{size}'>".html_safe +
        (unit ? "<div class='form-inline'>".html_safe : "") +
        form.send(xxxx, attribute, html_option) + " " + unit + 
        (unit ? "</div>".html_safe : "") +
        (description ?
          "<span class='help-block'>#{description}</span>" : "").html_safe +
        (example ?
          "<span class='help-block'><span class='label label-default'>例</span>#{example}</span>" : "").html_safe +
        "</div>".html_safe +
      "</div>".html_safe
    end

    # form_xxxx_tag (form_text_field_tag や form_text_area_tag) で呼び出されるメソッドです。
    def form_xxxx_tag(xxxx, name, label, size: 8, value: nil, description: nil, example: nil, required: true)
      html_option = required ?
          { class: 'form-control validation', required: true } :
          { class: 'form-control' }
      "<div class='form-group'>".html_safe +
        label('dummy',label, class: 'col-sm-2 control-label') +
        "<div class='col-sm-#{size}'>".html_safe +
        send(xxxx, name, value, html_option) +
        (description ?
          "<span class='help-block'>#{description}</span>" : "").html_safe +
        (example ?
          "<span class='help-block'><span class='label label-default'>例</span>#{example}</span>" : "").html_safe +
        "</div>".html_safe +
      "</div>".html_safe
    end

end
