﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LexisNexis.Red.Common.HelpClass.DomainEvent
{
    public interface IEventHandler<TEvent> where TEvent : IEvent
    {
        Task Handle(TEvent evt);
    }
}
