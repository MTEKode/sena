class EmotiQuestionsController < ApplicationController
  def index
    @questions = EmotiQuestion.active.map do |question|
      {
        order: question.order,
        key: question.key,
        translated_question: I18n.t(question.key),
        answer_keys: question.answer_keys.map { |answer_key| { answer_key: answer_key, translated_answer: I18n.t(answer_key) } }
      }
    end
  end

  def choose_emoti
    formated_questionnaire = "Respuestas del cuestionario:\n"
    params[:answers].each do |key, value|
      formated_questionnaire += " - #{I18n.t(key)}: #{I18n.t(value)}\n"
    end
    gpt_client = ChatApi::Gpt::EmotiSelectorClient.new
    response = gpt_client.send_message(formated_questionnaire)
    json_response = JSON.parse(response)
    emoti = Emoti.find_by(key: json_response['emoti_selected'])
    current_user.active_subscription.update_emoti_ids([emoti.id])

    redirect_to chat_path(emoti.id)
  end

  def questionnaire_params
    params.permit(:answers)
  end
end
