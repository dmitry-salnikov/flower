# encoding: UTF-8
require 'pry'
class Burger < SoundCommand
  respond_to 'burger'

  MAINS = [
    "Pork Belly",
    "Pulled Pork",
    "Chuck Roll Chili",
    "Louisiana Bangers",
    "Beef Brisket",
    "Sweet Potato Chili",
    "Portobello",
    "Southern Fried Fish",
    "Spicy BBQ Chick'n"
  ]

  SAUCES = [
    "Bacon BBQ",
    "Creamy Rooster",
    "Lemon Garlic",
    "Blue Cheese",
    "Tangy Mustard",
    "Hot Sauce",
    "Pico De Gallo",
    "Smoky BBQ",
    "Bourbon Apricot (XXXX)",
    "Creamy Chipotle",
    "Hot Jalapeno (XXX)"
  ]

  TOPPINGS = [
    "Kaleslaw",
    "Coleslaw",
    "Appleslaw",
    "Sauerslaw",
    "Sauerkraut",
    "Fried Egg"
  ]

  PERSONALS = [
    "Pickles",
    "Jalapeños",
    "Pickled Red Onion",
    "Kimchi",
    "Crisps",
    "Cellery"
  ]

  SIDE_DISHES = [
    "Green Salad",
    "Hot Chick'n Soup",
    "Portobello / Sweet Jams",
    "Fries",
  ]

  def self.description
    'Prints a random burger combination from Marie Laveau'
  end

  def self.respond(message)
    constants = self.constants
    your_burger = Array.new.tap do |burger|
      constants.each do |type|
        burger << "#{type.to_s.titleize.singularize}: #{self.const_get(type).sample}"
      end
    end

    message.paste your_burger
  end
end
