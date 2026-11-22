# Autodesk Inventor on Windows

This setup pairs the reusable [`inventor` agent](../../agents/codex/inventor.toml) with a local Autodesk Inventor session and Python COM automation.

1. Install and open Autodesk Inventor on Windows. Use the version required by the target project. The read-only COM check below was verified against Inventor 2027.2.
2. Copy the agent profile to `~/.codex/agents/inventor.toml`. For another harness, copy its description and instructions into that harness's user-level agent format. The harness needs to run Python on the same Windows desktop as Inventor.
3. Install `pywin32` into the Python environment the harness will use.

   ```powershell
   python -m pip install pywin32
   ```

4. With Inventor already open, run this read-only check to print the running application's version.

   ```powershell
   python -c 'import pythoncom; from win32com.client import dynamic; obj = pythoncom.GetActiveObject("Inventor.Application").QueryInterface(pythoncom.IID_IDispatch); print(dynamic.Dispatch(obj).SoftwareVersion.DisplayVersion)'
   ```

When assigning work, provide the target project or document path so the agent can confirm the intended file before editing. [Autodesk Inventor API reference](https://help.autodesk.com/cloudhelp/2027/ENU/Inventor-API/files/Application.htm)
