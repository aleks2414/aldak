class Service < ApplicationRecord
  
  
  
  default_scope { where(user_id: User.current.company.users.pluck(:id)) }

  belongs_to :user
  belongs_to :order, optional: true
  belongs_to :provider
  belongs_to :charter
  belongs_to :product
  belongs_to :client

  has_one_attached :image


  before_save :gasto_operacion
  before_save :total_venta
  before_save :status_com
  before_save :etapa
  before_save :ganancia
  before_save :proveedor
  before_save :fletera
  before_save :precio_de_compra
  before_save :precio_de_venta
  validate :fecha_entregable

  enum satisfaction: %w( bajo promedio alto )

def fecha_entregable
  if user.admin? || user.super_admin?
    start_time = Time.zone.now - 2.month - 1.day
    message = "No se puede crear una remisión de más o menos de 2 meses de distancia"
  else
    start_time = Time.zone.now - 1.day
    message = "No se puede crear una referencia de más de 2 meses de distancia o antes de hoy"
  end

  if self.fecha_de_entrega < start_time || self.fecha_de_entrega > (Time.zone.now + 2.month)
    errors.add(:service_id, message)
  end
end


def precio_de_venta
  self.precio_de_venta = self.product.precio_de_venta
end

def precio_de_compra
  self.precio_de_compra = self.product.costo_producto
end



def get_code
  number = 0
  codigo = ''

  loop do
    number += 1
    codigo = "#{self.client.try(:codigo_empresa)}-#{self.product.try(:codigo_producto)}-#{self.fecha_de_entrega.strftime("%d-%m-%Y")}-#{'%02d' % number}"
    break if Service.find_by(codigo_remision: codigo).nil?
  end

  codigo
end

  def proveedor
    self.proveedor =  self.cantidad_real_etregada * self.precio_de_compra
  end


def fletera
  self.fletera = self.charter.precio_de_envio
end
 

  def gasto_operacion
    self.gasto_operacion = self.proveedor + self.fletera
  end

  def total_venta
    self.total_venta = (self.try(:cantidad_real_etregada) * self.try(:precio_de_venta))
  end

  def ganancia
    self.ganancia = self.try(:total_venta) - self.try(:gasto_operacion)

  end

  def status_com
    if self.pagado == true 
      self.status_comercial = "Cobrado"
    else 
      self.status_comercial = "Por Cobrar"
    end
  end


  def etapa
    if self.cantidad_real_etregada > 0
      if self.gr.present?
        if self.numero_de_factura.present? && self.fecha_de_facturacion.present?
          if self.fecha_por_cobrar.present?
            self.etapa = 5
          else
            self.etapa = 4
          end
        else
          self.etapa = 3
        end
      else
        self.etapa = 2
      end
    else
      self.etapa = 1
    end
  end

  def month
    self.fecha_de_entrega.to_date.strftime('%G-%B')
  end

  def year
    self.fecha_de_entrega.to_date.strftime('%Y')
  end

  def order_name=(name)
    self.order = Order.find_by_numero_de_orden(name.split(',').first) if name.present?
  end
end
