using System;

class psharp
{
    static void Main(string[] args)
    {
    
    }
    
    public static string FindNamespace([string] method){
        Type myType = typeof(method);
        return myType.Namspace;
    }
}