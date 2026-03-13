class_name SoldierData
extends Resource

## Data resource defining a soldier type.
## Create .tres files in resources/entity_configs/ to add new soldiers.

@export var id: String = ""
@export var display_name: String = ""
@export var description: String = ""
@export var cost: int = 15                # in-match spawn cost (coins)
@export var unlock_price: int = 0         # persistent coin price (0 = free/default)
@export var move_speed: float = 300.0
@export var max_range: float = 600.0
@export var max_health: int = 30
@export var attack_damage: int = 10
@export var attack_cooldown: float = 0.8
@export var lifetime: float = 30.0
@export var color: Color = Color.WHITE
@export var icon: Texture2D = null
@export var front_texture: Texture2D = null
@export var back_texture: Texture2D = null
@export var left_texture: Texture2D = null
@export var right_texture: Texture2D = null
@export var animation_root: String = ""
@export var sprite_scale: Vector2 = Vector2.ONE
@export var is_premium: bool = false      # true = IAP only, not coin-buyable
@export var sort_order: int = 0           # controls display order in store/cycling
