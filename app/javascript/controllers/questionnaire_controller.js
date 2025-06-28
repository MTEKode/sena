import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [
        "questionContainer",
        "optionsContainer",
        "prevButton",
        "nextButton"
    ]
    static values = {
        questions: Array,
        sendQuestionsUrl: String
    }

    connect() {
        this.currentQuestionIndex = 0
        this.questionAnswerHash = {}
        this.updateButtonStates()
        this.showQuestion()
    }

    showQuestion() {
        const question = this.questionsValue[this.currentQuestionIndex]
        const selectedOption = this.questionAnswerHash[question.key]
        this.questionContainerTarget.innerHTML = `<h3>${question.translated_question}</h3>`

        this.optionsContainerTarget.innerHTML = question.answer_keys.map(option =>
            `<button class="option-button ${selectedOption === option.answer_key ? 'selected' : ''}" data-action="click->questionnaire#selectOption" data-option="${option.answer_key}">${option.translated_answer}</button>`
        ).join('')
    }

    updateButtonStates() {
        // Botón Anterior
        this.prevButtonTarget.disabled = this.currentQuestionIndex === 0
        this.nextButtonTarget.disabled = Object.keys(this.questionAnswerHash).length < this.questionsValue.length
    }

    selectOption(event) {
        this.optionsContainerTarget.querySelectorAll('.option-button').forEach(btn => {
            btn.classList.remove('selected')
        })

        const selectedButton = event.currentTarget
        selectedButton.classList.add('selected')

        const selectedOption = event.target.dataset.option
        const question = this.questionsValue[this.currentQuestionIndex]
        this.questionAnswerHash[question.key] = selectedOption
        this.nextQuestion()

        this.updateButtonStates()
    }

    nextOrFinish() {
        if (this.currentQuestionIndex === this.questionsValue.length - 1) {
            this.finishQuestionnaire()
        } else {
            this.nextQuestion()
        }
    }

    nextQuestion() {
        if (this.currentQuestionIndex < this.questionsValue.length - 1) {
            this.currentQuestionIndex++
            this.showQuestion()
        }
    }

    prevQuestion() {
        if (this.currentQuestionIndex > 0) {
            this.currentQuestionIndex--
            this.showQuestion()
        }
    }

    finishQuestionnaire() {
        console.log("Respuestas completadas:", this.questionAnswerHash)
        console.log(this.sendQuestionsUrlValue)
        // Aquí iría la lógica para enviar las respuestas al servidor
        // Ejemplo con fetch:
        fetch(this.sendQuestionsUrlValue, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
            },
            body: JSON.stringify({ answers: this.questionAnswerHash })
        }).then(response => {
            console.log(response)
        })
    }
}