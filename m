Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9970DDFA17
	for <lists+linux-fscrypt@lfdr.de>; Tue, 22 Oct 2019 03:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbfJVBXQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 21 Oct 2019 21:23:16 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:33876 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbfJVBXO (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 21 Oct 2019 21:23:14 -0400
Received: by mail-il1-f195.google.com with SMTP id c12so13897705ilm.1
        for <linux-fscrypt@vger.kernel.org>; Mon, 21 Oct 2019 18:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=HxSTurX1jmsAhOfpsGghsXLIvTQPCzV7aaceHn58k98=;
        b=EJecjF3+nEd1bVBO0x2r9May2yxPiA5i56nJtsaPHWNOunlSAVJaQ72R714XCXmt5g
         qE7uHOx26GVMiQ3tcxzHITeZ4z8sVJgAbNiZ98i/6py1pkF7Ngndur9vlJSB0Eefa83m
         jsoHwwRG7dWcdt6lwh8uauXOTh6Eh1P7i+tN9NmM3rzKNaj8Hwv6aDf8v/87QCWwpVVh
         3h5viIHtwHM9X4krDKGy56i+0gPNpeM8HLwmYJcZgbhiHdoklanfbeSAVJ2pg7vfXZp9
         bV6tuKUFo5++0D/tFiZoTbVksgQTOnOdi4ScAp2G4HxODcbbVAq3wVbTINg0UbSmzB8l
         L10g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=HxSTurX1jmsAhOfpsGghsXLIvTQPCzV7aaceHn58k98=;
        b=OS3qy0TEjWqZWwy19n1INrrykPMxUkZ91P+8h9Trpw6NN2uTVqQdW8Mnwik0S/ROzK
         6GuCSBqmLn/zj4aowIJPj90NKz+Qxa3DieD6Omgr5i99baH3wCOgWen7HFeG13PH99n6
         whA3W80PPsaygOuxht/8knGmmCVwmF07duZvrBz4TW38jzhvNjMR2EV3CxHOFr2MuXqx
         ibZBzxv5ZXJNIVbsYBHkapKsNfWzMdDlfAQ2geF5Cq7f/TTs+IvAwvA1beU1HafAe4Cu
         CTVt4qyBw23Y7fcPELu8iPpEMYMAbF03cOOU+yToC7Ln1ZWUjjHslPzggpO2phV4SWB5
         wggg==
X-Gm-Message-State: APjAAAUSERAJIevRkv83tS76rv5vZ8+dhqZTD/COPCCaxL61NaPp3BLA
        f4H1cAsnBEo9QbltMgcMIvtt5A==
X-Google-Smtp-Source: APXvYqwDxSFEQy2XdZlfsF/YxbIAJJAlAeHn1v5sEQT7bVF2SswsEb++F6PWyZ24fGTNgL+h7v0irA==
X-Received: by 2002:a92:d784:: with SMTP id d4mr30026867iln.1.1571707393182;
        Mon, 21 Oct 2019 18:23:13 -0700 (PDT)
Received: from localhost (67-0-11-246.albq.qwest.net. [67.0.11.246])
        by smtp.gmail.com with ESMTPSA id v17sm5902825ilg.1.2019.10.21.18.23.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 18:23:12 -0700 (PDT)
Date:   Mon, 21 Oct 2019 18:23:11 -0700 (PDT)
From:   Paul Walmsley <paul.walmsley@sifive.com>
X-X-Sender: paulw@viisi.sifive.com
To:     Eric Biggers <ebiggers@kernel.org>
cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fscrypt@vger.kernel.org
Subject: Re: arch/riscv doesn't support xchg() on bool
In-Reply-To: <20191021204026.GE122863@gmail.com>
Message-ID: <alpine.DEB.2.21.9999.1910211744450.28831@viisi.sifive.com>
References: <20191021204026.GE122863@gmail.com>
User-Agent: Alpine 2.21.9999 (DEB 301 2018-08-15)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Eric,

On Mon, 21 Oct 2019, Eric Biggers wrote:

> The kbuild test robot reported a build error on RISC-V in this patch:
> 
> 	https://patchwork.kernel.org/patch/11182389/
> 
> ... because of the line:
> 
> 	if (!xchg(&mode->logged_impl_name, true)) {
> 
> where logged_impl_name is a 'bool'.  The problem is that unlike most (or 
> all?) other kernel architectures, arch/riscv/ doesn't support xchg() on 
> bytes.

When I looked at this in August, it looked like several Linux other 
architectures - SPARC, Microblaze, C-SKY, and Hexagon - also didn't 
support xchg() on anything other than 32-bit types:

https://lore.kernel.org/lkml/alpine.DEB.2.21.9999.1908161931110.32497@viisi.sifive.com/

Examples:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/sparc/include/asm/cmpxchg_32.h#n18

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/sparc/include/asm/cmpxchg_32.h#n41

> Is there any chance this could be implemented, to avoid this
> architecture-specific quirk?

It is certainly possible.  I wonder whether it is wise.  Several of the 
other architectures implement a software workaround for this operation, 
and I guess you're advocating that we do the same.  We could copy one 
these implementations.  However, the workarounds balloon into quite a lot 
of code.  Here is an example from MIPS:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/mips/kernel/cmpxchg.c#n10

I could be wrong, but I think this expansion would be pretty surprising 
for most users of xchg().  I suspect most xchg() users are looking for 
something performant, and would be better served by simply using a 
variable with a 32-bit type.

In the case of your patch, it appears that struct 
fscrypt_mode.logged_impl_name is only used in the patched function.  It 
looks like it could be promoted into a u32 without much difficulty.  
Would you be willing to consider that approach of solving the problem?  
Then the code would be able to take advantage of the fast hardware 
implementation that's available on many architectures (including RISC-V).

> Note, there's at least one other place in the kernel that also uses 
> xchg() on a bool.

Given the nasty compatibility code, I wonder if we'd be better served by 
removing most of this compatibility code across the kernel, and just 
requiring callers to use a 32-bit type?  For most callers that I've seen, 
this doesn't seem to be much of an issue; and it would avoid the nasty 
code involved in software emulations of xchg().


- Paul
