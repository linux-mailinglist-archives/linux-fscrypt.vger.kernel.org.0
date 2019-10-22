Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09CD5DFA3D
	for <lists+linux-fscrypt@lfdr.de>; Tue, 22 Oct 2019 03:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728375AbfJVBpG (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 21 Oct 2019 21:45:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727264AbfJVBpG (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 21 Oct 2019 21:45:06 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8A822166E;
        Tue, 22 Oct 2019 01:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571708705;
        bh=Z9fN3zd+PcUP2OO28Tpt6wFJZgF3dMPAo7VcQb/U9I8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U0i1b5ekWUAVk+pezKqLDBwQO2VTdkPGR7Mb1hIlrgdqn2GaX+ium6MWFGHyzLLRr
         /+fDc4Gy16Zvxko6dPbUoIf8IPqsSOw+3cSWhi8SD69bJ2w88lMsPJWQha/Yzsg0yH
         C2iE6CDGM0Zpst5AA05hjnMMK25wvjZeiMjhoMW4=
Date:   Mon, 21 Oct 2019 18:45:03 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Paul Walmsley <paul.walmsley@sifive.com>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fscrypt@vger.kernel.org
Subject: Re: arch/riscv doesn't support xchg() on bool
Message-ID: <20191022014503.GA938@sol.localdomain>
Mail-Followup-To: Paul Walmsley <paul.walmsley@sifive.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fscrypt@vger.kernel.org
References: <20191021204026.GE122863@gmail.com>
 <alpine.DEB.2.21.9999.1910211744450.28831@viisi.sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.9999.1910211744450.28831@viisi.sifive.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Paul,

On Mon, Oct 21, 2019 at 06:23:11PM -0700, Paul Walmsley wrote:
> Hi Eric,
> 
> On Mon, 21 Oct 2019, Eric Biggers wrote:
> 
> > The kbuild test robot reported a build error on RISC-V in this patch:
> > 
> > 	https://patchwork.kernel.org/patch/11182389/
> > 
> > ... because of the line:
> > 
> > 	if (!xchg(&mode->logged_impl_name, true)) {
> > 
> > where logged_impl_name is a 'bool'.  The problem is that unlike most (or 
> > all?) other kernel architectures, arch/riscv/ doesn't support xchg() on 
> > bytes.
> 
> When I looked at this in August, it looked like several Linux other 
> architectures - SPARC, Microblaze, C-SKY, and Hexagon - also didn't 
> support xchg() on anything other than 32-bit types:
> 
> https://lore.kernel.org/lkml/alpine.DEB.2.21.9999.1908161931110.32497@viisi.sifive.com/
> 
> Examples:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/sparc/include/asm/cmpxchg_32.h#n18
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/sparc/include/asm/cmpxchg_32.h#n41
> 
> > Is there any chance this could be implemented, to avoid this
> > architecture-specific quirk?
> 
> It is certainly possible.  I wonder whether it is wise.  Several of the 
> other architectures implement a software workaround for this operation, 
> and I guess you're advocating that we do the same.  We could copy one 
> these implementations.  However, the workarounds balloon into quite a lot 
> of code.  Here is an example from MIPS:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/mips/kernel/cmpxchg.c#n10
> 
> I could be wrong, but I think this expansion would be pretty surprising 
> for most users of xchg().  I suspect most xchg() users are looking for 
> something performant, and would be better served by simply using a 
> variable with a 32-bit type.
> 
> In the case of your patch, it appears that struct 
> fscrypt_mode.logged_impl_name is only used in the patched function.  It 
> looks like it could be promoted into a u32 without much difficulty.  
> Would you be willing to consider that approach of solving the problem?  
> Then the code would be able to take advantage of the fast hardware 
> implementation that's available on many architectures (including RISC-V).

Yes, I already sent a new version of the patch, which changes the variable to an
int: https://patchwork.kernel.org/patch/11203003/.  I was wondering more about
how to stop other people from running into this.

> 
> > Note, there's at least one other place in the kernel that also uses 
> > xchg() on a bool.
> 
> Given the nasty compatibility code, I wonder if we'd be better served by 
> removing most of this compatibility code across the kernel, and just 
> requiring callers to use a 32-bit type?  For most callers that I've seen, 
> this doesn't seem to be much of an issue; and it would avoid the nasty 
> code involved in software emulations of xchg().
> 

It's possible that's the better approach; someone would need to go through all
the xchg() users and check whether any truly need the 8 or 16-bit support.  My
main concern was just the annoyance of code that only fails to compile on
certain architectures.  It should either be one way or the other everywhere.

- Eric
