shader_type canvas_item;

// Параметры искривления
uniform float curvature : hint_range(0.0, 0.1) = 0.02;
uniform float edge_curvature : hint_range(0.0, 0.15) = 0.05;

// Функция баррельного искажения (искривление по краям)
vec2 barrel_distortion(vec2 uv, float strength) {
    // Центрируем UV координаты
    vec2 centered_uv = uv - 0.5;
    
    // Рассчитываем расстояние от центра
    float dist = length(centered_uv);
    
    // Применяем квадратичное искажение
    float distortion_factor = 1.0 + strength * dist * dist;
    
    // Искажаем координаты
    vec2 distorted_uv = centered_uv * distortion_factor;
    
    // Возвращаем к нормальным координатам
    return distorted_uv + 0.5;
}

// Функция эллиптического искривления (скругление углов)
vec2 elliptical_distortion(vec2 uv, float strength) {
    vec2 centered_uv = uv - 0.5;
    
    // Создаем эллиптическое искажение
    vec2 distortion = centered_uv * (1.0 - strength * centered_uv * centered_uv * 4.0);
    
    return distortion + 0.5;
}

void fragment() {
    vec2 original_uv = UV;
    
    // Комбинируем оба типа искривления
    vec2 distorted_uv = barrel_distortion(original_uv, curvature);
    distorted_uv = elliptical_distortion(distorted_uv, edge_curvature);
    
    // Обрезаем пиксели за пределами экрана для создания скругленных углов
    if (distorted_uv.x < 0.0 || distorted_uv.x > 1.0 || distorted_uv.y < 0.0 || distorted_uv.y > 1.0) {
        COLOR = vec4(0.0, 0.0, 0.0, 1.0); // Черная рамка
    } else {
        // Берем цвет из текстуры с искаженными координатами
        COLOR = texture(TEXTURE, distorted_uv);
    }
}