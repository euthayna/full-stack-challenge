import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "comment", "status" ]

  initialComment = '';
  initialStatus = '';

  initialize() {
    this.initialComment = this.commentTarget.value;
    this.initialStatus = this.statusTarget.value;
  }

  changeCommentInputText() {
    if(this.statusTarget.value == this.initialStatus) {
      this.commentTarget.value = this.initialComment;
    } else {
      this.commentTarget.value = '';
    }
  }
}