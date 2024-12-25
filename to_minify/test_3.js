function initialize_option_checkbox() {
	const optional_checkbox = document.querySelector('.optional-checkbox');
	const optional_content = document.querySelector('.optional');

	if(!optional_checkbox)
		return;

	optional_checkbox.addEventListener('change', () => {
		const input_file = optional_content.querySelector('.input_file');

		if(optional_checkbox.checked) {
			optional_content.classList.remove('hide');
			input_file.setAttribute('required', true);
		}
		else {
			optional_content.classList.add('hide');
			input_file.removeAttribute('required');
		}
	});
}

function attribute_titles_to_panels() {
	const functions_titles = document.querySelectorAll('.function-title');
	const functions_panels = document.querySelectorAll('.functions-panel');

	if(!functions_titles)
		return;

	functions_titles.forEach(functions_title => {
		functions_title.addEventListener('click', () => {

			// Reset style
			functions_titles.forEach(functions_title => {
				functions_title.classList.remove('selected');
			});

			functions_panels.forEach(functions_panel => {
				functions_panel.classList.add('hide');
			});

			// Update style on the selected one
			const data_id = functions_title.attributes['data-id'].nodeValue;
			document.getElementById(data_id).classList.remove('hide');
			functions_title.classList.add('selected');
		});
	});
}

function attribute_update_inputs_to_panels() {
	const update_panel = document.querySelector('.open-update-panel');

	if(!update_panel)
		return;

	const radio_inputs = update_panel.querySelectorAll('.input_radio');
	const project_infos_panels = document.querySelectorAll('.project-infos');

	radio_inputs.forEach(radio_input => {
		radio_input.addEventListener('change', () => {
			project_infos_panels.forEach(project_infos_panel => {
				project_infos_panel.classList.add('hide');

				if(project_infos_panel.attributes['data-id'].nodeValue == radio_input.id)
					project_infos_panel.classList.remove('hide');
			});
		});
	});
}

function activate_popup_fade_out() {
	var popup = document.querySelector('.popup');

	if(!popup)
		return;

	setTimeout(function() {
		popup.classList.add('fade-out');
	}, 5000);
}

function initialize_customs_input_file() {
    const inputs_file = document.querySelectorAll('.input_file');

	if(!inputs_file)
		return;

	inputs_file.forEach(input_file => {
		input_file.addEventListener('change', (event) => {
			const new_filename = event.target.files[0].name;
			const fake_input = input_file.nextElementSibling;
			console.log(new_filename);
			fake_input.innerHTML = new_filename;
		});
	});
}

function update_competence_category_on_delete() {
	const competence_choice = document.querySelector('.competence_list');

	if(!competence_choice)
		return;

	competence_choice.addEventListener('change', () => {
		const selected_option = competence_choice.options[competence_choice.selectedIndex];
		const optgroup = selected_option.parentElement;

		document.getElementById('category').value = optgroup.label;
	});
}