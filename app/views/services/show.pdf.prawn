prawn_document() do |pdf|
  logo = "#{Rails.root}/app/assets/images/tutto-07.png"
	pdf.image logo, width: 120, position: :left
	pdf.move_down 5
	pdf.text "H. Remisión:", size: 10, align: :right
	pdf.move_down 5
	pdf.text "#{@service.codigo_remision}", size: 10, align: :right

	pdf.move_down 10
	pdf.text "Número de Pedido:", size: 10, align: :right
	pdf.move_down 5
	pdf.text "#{@service.order.numero_de_orden}", size: 10, align: :right

	pdf.move_down 10
	pdf.text "Número de Proveedor:", size: 10, align: :left
	pdf.move_down 5
	pdf.text "#{@service.order.numero_de_orden}", size: 10, align: :left

	pdf.move_down 1
	pdf.text "#{@service.created_at.strftime(" %d-%b-%Y")}", size: 12, style: :bold, align: :right


	pdf.move_down 25
	pdf.text "Atn: #{@service.order.nombre_encargado}", size: 13, align: :left
	pdf.move_down 5
	pdf.text "#{@service.order.client.razon_social}", size: 11, align: :left


	pdf.move_down 45
	pdf.text "HOJA DE REMISIÓN", size: 13, align: :center, style: :bold
	pdf.move_down 5
	pdf.text "POR CONCEPTO DE", size: 11, align: :center

	pdf.move_down 15
	# aqui
data = [ 
 ["Cantidad:", "Unidad:", "Descripción del Producto"],
 ["#{@service.cantidad}", "Kilos", "#{@service.order.product.caracteristicas}"]
 ]

pdf.table data, :position => :center, :width => 550, :row_colors => ["F6F6F6", "F6F6F6"], :column_widths => [183, 183], :cell_style => { :font => "Helvetica", :size => 10, :border_color => "000000" }

	pdf.move_down 165
	pdf.move_down 5
	pdf.text "Autorizó:", size: 10, align: :left
	pdf.text "ING. JORGE AZPEITIA", size: 13, align: :left
	pdf.move_down 5
	pdf.text "Encargado de salidas de almacén", size: 11, align: :left

	pdf.move_down 80
	pdf.text "ANDAK GLOBAL SOLUTIONS S.A DE C.V", size: 10, align: :center, style: :bold
	pdf.move_down 5
	pdf.stroke_horizontal_rule
	pdf.move_down 10
	pdf.text "Punta Esmeralda Edi 2A dep 203, Col. Bosque Esmeralda, Atizapan, Estado de México, C.P. 52930", size: 9, align: :center
	pdf.move_down 5
	pdf.text "Teléfono: 5344-4558 correo electrónico: contacto@andak.com.mx", size: 9, align: :center
	pdf.move_down 5
	pdf.text "www.andak.com.mx", size: 9, align: :center

end