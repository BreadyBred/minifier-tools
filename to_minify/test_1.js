function get_palette() {
	return document.cookie
	.split('; ')
	.find(row => row.startsWith('color_palette='))
	.split('=')[1];
}

async function load_palettes() {
    const response = await fetch(get_site_root() + 'data/utilities.json');
    const data = await response.json();
    palettes = data.palettes || [];
}

function get_active_palettes_amount() {
	return palettes.length;
}

function choose_palette(palette_id) {
	let current_date = new Date();
	current_date.setFullYear(current_date.getFullYear() + 10);
	let expires = current_date.toUTCString();

	document.cookie = "color_palette=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/; SameSite=None; Secure";
	document.cookie = `color_palette=${palette_id}; expires=${expires}; path=/; SameSite=None; Secure`;
	initialize_palette(get_palette(), false);
}

function initialize_palette(set_palette, landing = true) {
	/*
	element - color_type
	element - color_type - palette

	elements:
		a: accent
		ac: accent-seethrough
		aux: auxiliary
		bg: background
		s: secondary
		
	color_types:
		ac: accent-color
		bg: background
		bc: border-color
		bs: box-shadow
		fc: font-color
		tdc: text-decoration-color
	*/
	const elements = ['a', 'as', 'aux', 'bg', 's'];
	const color_types = ['ac', 'bc', 'bg', 'bs', 'fc', 'tdc'];

	// Elements généraux
	elements.forEach(element => {
		color_types.forEach(color_type => {
			const elements_on_page = document.querySelectorAll('.' + element + '-' + color_type);
			elements_on_page.forEach(element_on_page => {
				const class_name = element + '-' + color_type + '-';
				remove_classes_from_element(element_on_page, class_name);

				element_on_page.classList.add(class_name + set_palette);
			});
			
			const elements_on_page_hover = document.querySelectorAll('.' + element + '-' + color_type + '-hv');
			elements_on_page_hover.forEach(element_on_page_hover => {
				const class_name = element + '-' + color_type + '-';
				remove_classes_from_element(element_on_page_hover, class_name, 'hover');

				element_on_page_hover.classList.add(class_name + '-hv-' + set_palette);
			});
		});
	});

	// Boutons
	const buttons = document.querySelectorAll('.button');
	buttons.forEach(button => {
		const class_name = 'button-';
		remove_classes_from_element(button, class_name);
		
		button.classList.add(class_name + set_palette);
	});

	// Changement dynamique de palette
	if(!landing) {
		// Favicon
		change_source(document.querySelector('link[rel="shortcut icon"]'), 'href', set_palette);

		// Logo
		document.getElementById('main-logo').src = `${get_images_folder()}logo/${set_palette}/logo_256.png`;

		// CV
		// change_source(document.querySelector('#cv-file'), 'href', set_palette);

		// Compétences
		document.querySelectorAll('.competence').forEach(competence => {
			let previous_src = competence.src;
			palettes.forEach(palette => {
				// auxiliary color
				previous_src = previous_src.replace(palette[0], palettes[set_palette][0]);

				// accent color
				previous_src = previous_src.replace(palette[1], palettes[set_palette][1]);

				competence.src = previous_src;
			});
		});

		// Logo contact
		document.querySelectorAll('.contact-logo').forEach(contact_logo => {
			change_source(contact_logo, 'src', set_palette);
		});
	}
}

function change_source(target, type, new_palette) {
	let previous_source = (type == 'href') ? target.href : target.src;
	for (let i = 0; i <= get_active_palettes_amount(); i++)
		if (previous_source.includes(i.toString()))
			if(type == 'href')
				target.href = previous_source.split(i.toString()).join(new_palette);
			else
			target.src = previous_source.split(i.toString()).join(new_palette);
}

function remove_classes_from_element(element, class_name, type = null) {
	let additional_parameter;
	switch(type) {
		case 'hover':
			additional_parameter = 'hv-';
			break;
		default:
			additional_parameter = '';
			break;
	}

	for(let i = 0; i < get_active_palettes_amount(); i++)
		element.classList.remove(class_name + additional_parameter + i);
}

function hide_panels(event = {}) {
    const is_trigger = event.target?.classList.contains('palette-trigger');
    document.querySelectorAll('.palette').forEach(element => {
        element.style.display = is_trigger && element.style.display !== 'block' ? 'block' : 'none';
    });
}