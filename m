Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02E49752DF6
	for <lists+linux-fscrypt@lfdr.de>; Fri, 14 Jul 2023 01:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233496AbjGMXbi (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 13 Jul 2023 19:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbjGMXbh (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 13 Jul 2023 19:31:37 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 33A85269D;
        Thu, 13 Jul 2023 16:31:36 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id 4D4A221C450A; Thu, 13 Jul 2023 16:31:35 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4D4A221C450A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1689291095;
        bh=RL+a/gvtQRcDwaoV7SYgH/JAWrvPiZ941LY3UGXpd+s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KnYf/qNYjVOfMXTsuhjiVAi4/SyVcO2iNL0wLlN1dLTqlrob5wrXmz1m+a0qZM0MT
         t1JoTcoUoCdw5aRtjHPovyWUh1ZFSfHvvpl2zDoOL8IICpVDDaO+6JDWvHhfipi9EC
         ADhDruEL1rxlB+wtAxBRlZYV+bOMMQvIc9TihJKo=
Date:   Thu, 13 Jul 2023 16:31:35 -0700
From:   Fan Wu <wufan@linux.microsoft.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
        axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        eparis@redhat.com, linux-doc@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, audit@vger.kernel.org,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [PATCH RFC v10 1/17] security: add ipe lsm
Message-ID: <20230713233135.GA11480@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1687986571-16823-2-git-send-email-wufan@linux.microsoft.com>
 <ffd5c67f4a9bf45df0ce95a8fe0932a3.paul@paul-moore.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ffd5c67f4a9bf45df0ce95a8fe0932a3.paul@paul-moore.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-17.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sat, Jul 08, 2023 at 12:22:59AM -0400, Paul Moore wrote:
> On Jun 28, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> > 
> > Integrity Policy Enforcement (IPE) is an LSM that provides an
> > complimentary approach to Mandatory Access Control than existing LSMs
> > today.
> > 
> > Existing LSMs have centered around the concept of access to a resource
> > should be controlled by the current user's credentials. IPE's approach,
> > is that access to a resource should be controlled by the system's trust
> > of a current resource.
> > 
> > The basis of this approach is defining a global policy to specify which
> > resource can be trusted.
> > 
> > Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> > Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> > ---
> >  MAINTAINERS           |  7 +++++++
> >  security/Kconfig      | 11 ++++++-----
> >  security/Makefile     |  1 +
> >  security/ipe/Kconfig  | 17 +++++++++++++++++
> >  security/ipe/Makefile | 10 ++++++++++
> >  security/ipe/ipe.c    | 37 +++++++++++++++++++++++++++++++++++++
> >  security/ipe/ipe.h    | 16 ++++++++++++++++
> >  7 files changed, 94 insertions(+), 5 deletions(-)
> >  create mode 100644 security/ipe/Kconfig
> >  create mode 100644 security/ipe/Makefile
> >  create mode 100644 security/ipe/ipe.c
> >  create mode 100644 security/ipe/ipe.h
> 
> ...
> 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index a82795114ad4..ad00887d38ea 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -10278,6 +10278,13 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity.git
> >  F:	security/integrity/
> >  F:	security/integrity/ima/
> >  
> > +INTEGRITY POLICY ENFORCEMENT (IPE)
> > +M:	Fan Wu <wufan@linux.microsoft.com>
> > +L:	linux-security-module@vger.kernel.org
> > +S:	Supported
> > +T:	git git://github.com/microsoft/ipe.git
> 
> Using the raw git protocol doesn't seem to work with GH, I think you
> need to refernce the git/https URL:
> 
>  https://github.com/microsoft/ipe.git
> 
Sure I can change it.

> > +F:	security/ipe/
> > +
> >  INTEL 810/815 FRAMEBUFFER DRIVER
> >  M:	Antonino Daplas <adaplas@gmail.com>
> >  L:	linux-fbdev@vger.kernel.org
> > diff --git a/security/Kconfig b/security/Kconfig
> > index 97abeb9b9a19..daa4626ea99c 100644
> > --- a/security/Kconfig
> > +++ b/security/Kconfig
> > @@ -202,6 +202,7 @@ source "security/yama/Kconfig"
> >  source "security/safesetid/Kconfig"
> >  source "security/lockdown/Kconfig"
> >  source "security/landlock/Kconfig"
> > +source "security/ipe/Kconfig"
> >  
> >  source "security/integrity/Kconfig"
> >  
> > @@ -241,11 +242,11 @@ endchoice
> >  
> >  config LSM
> >  	string "Ordered list of enabled LSMs"
> > -	default "landlock,lockdown,yama,loadpin,safesetid,smack,selinux,tomoyo,apparmor,bpf" if DEFAULT_SECURITY_SMACK
> > -	default "landlock,lockdown,yama,loadpin,safesetid,apparmor,selinux,smack,tomoyo,bpf" if DEFAULT_SECURITY_APPARMOR
> > -	default "landlock,lockdown,yama,loadpin,safesetid,tomoyo,bpf" if DEFAULT_SECURITY_TOMOYO
> > -	default "landlock,lockdown,yama,loadpin,safesetid,bpf" if DEFAULT_SECURITY_DAC
> > -	default "landlock,lockdown,yama,loadpin,safesetid,selinux,smack,tomoyo,apparmor,bpf"
> > +	default "landlock,lockdown,yama,loadpin,safesetid,smack,selinux,tomoyo,apparmor,bpf,ipe" if DEFAULT_SECURITY_SMACK
> > +	default "landlock,lockdown,yama,loadpin,safesetid,apparmor,selinux,smack,tomoyo,bpf,ipe" if DEFAULT_SECURITY_APPARMOR
> > +	default "landlock,lockdown,yama,loadpin,safesetid,tomoyo,bpf,ipe" if DEFAULT_SECURITY_TOMOYO
> > +	default "landlock,lockdown,yama,loadpin,safesetid,bpf,ipe" if DEFAULT_SECURITY_DAC
> > +	default "landlock,lockdown,yama,loadpin,safesetid,selinux,smack,tomoyo,apparmor,bpf,ipe"
> 
> Generally speaking the BPF LSM should be the last entry in the LSM
> list to help prevent issues caused by a BPF LSM returning an improper
> error and shortcutting a LSM after it.
> 
Thanks for the insight, I will update this part.

> >  	help
> >  	  A comma-separated list of LSMs, in initialization order.
> >  	  Any LSMs left off this list, except for those with order
> 
> ...
> 
> > diff --git a/security/ipe/Makefile b/security/ipe/Makefile
> > new file mode 100644
> > index 000000000000..571648579991
> > --- /dev/null
> > +++ b/security/ipe/Makefile
> > @@ -0,0 +1,10 @@
> > +# SPDX-License-Identifier: GPL-2.0
> > +#
> > +# Copyright (C) Microsoft Corporation. All rights reserved.
> > +#
> > +# Makefile for building the IPE module as part of the kernel tree.
> > +#
> > +
> > +obj-$(CONFIG_SECURITY_IPE) += \
> > +	hooks.o \
> > +	ipe.o \
> 
> It doesn't look like security/ipe/hook.c is included in this patch.
> 
> It is important to ensure that each patch compiles after it is
> applied.
Sorry this was accidentally added during a rebase, I will try to avoid such a mistake in the future.

-Fan

> 
> --
> paul-moore.com
