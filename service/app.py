from flask import Flask, jsonify, render_template_string, request

app = Flask(__name__)

HTML = """
<!doctype html>
<html>
  <head><meta charset="utf-8"><title>Service</title></head>
  <body style="font-family: system-ui, -apple-system, Roboto, 'Segoe UI', sans-serif; display:flex;align-items:center;justify-content:center;height:100vh;background:linear-gradient(135deg,#a0e9ff,#ffd6e0);">
    <div style="background: rgba(255,255,255,0.9); padding: 2rem; border-radius: 10px; box-shadow: 0 6px 18px rgba(0,0,0,0.08); text-align:center;">
  <h1>Hi — Simple Microservice</h1>
  <p>This service is running (Flask).</p>
    </div>
  </body>
</html>
"""


@app.route("/")
def index():
    # return HTML when requested by browser
    if request.headers.get("Accept", "").find("text/html") != -1 or request.args.get("format") != "json":
        return render_template_string(HTML)
    return jsonify(message="Hi — Simple Microservice")


@app.route("/health")
def health():
    return jsonify(status="ok")


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
