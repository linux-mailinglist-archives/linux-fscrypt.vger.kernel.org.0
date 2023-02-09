Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6648A69132A
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Feb 2023 23:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjBIWV5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Feb 2023 17:21:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbjBIWV4 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Feb 2023 17:21:56 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 17EC331E01;
        Thu,  9 Feb 2023 14:21:54 -0800 (PST)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id 89F6A20C8AF3; Thu,  9 Feb 2023 14:21:53 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 89F6A20C8AF3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1675981313;
        bh=RUdC5B9WQx/P13jBYCe9d9UCa08CXDooaF6pn5xM0XU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ACCtgB1V7Pj9HpbZCzfkwRaa8mEyqbQ0An9AlLvmPyHKDFnGuWFzikGMzAkAnnOnV
         6un5wxDChEKMJoG7iGI7AGL8y3IjmRdgvalSdG1Nt3mQ4jy/DFmmUFx2did+hj91Sf
         +O7rYKknS0EHfFnT9Mu+AfuLB7ZENeKJWbKO5+wU=
Date:   Thu, 9 Feb 2023 14:21:53 -0800
From:   Fan Wu <wufan@linux.microsoft.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, axboe@kernel.dk, agk@redhat.com,
        snitzer@kernel.org, eparis@redhat.com, paul@paul-moore.com,
        linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-audit@redhat.com,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [RFC PATCH v9 12/16] fsverity: consume builtin signature via LSM
 hook
Message-ID: <20230209222153.GA6647@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-13-git-send-email-wufan@linux.microsoft.com>
 <Y+Ro2Uor21d/Gfqc@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+Ro2Uor21d/Gfqc@sol.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Feb 08, 2023 at 07:30:33PM -0800, Eric Biggers wrote:
> So disregarding the fact that using the fsverity builtin signatures still seems
> like a bad idea to me, here's a few comments on the diff itself:
> 
Thanks for the review. I have verified the headers are indeed unnecessary,
I will remove them in the next version.

> On Mon, Jan 30, 2023 at 02:57:27PM -0800, Fan Wu wrote:
> > diff --git a/fs/verity/open.c b/fs/verity/open.c
> > index 81ff94442f7b..7e6fa52c0e9c 100644
> > --- a/fs/verity/open.c
> > +++ b/fs/verity/open.c
> > @@ -7,7 +7,9 @@
> >  
> >  #include "fsverity_private.h"
> >  
> > +#include <linux/security.h>
> >  #include <linux/slab.h>
> > +#include <crypto/public_key.h>
> 
> There's no need to include <crypto/public_key.h>.
> 
> >  
> > +	if (err) {
> > +		fsverity_err(inode, "Error %d verifying signature", err);
> > +		goto out;
> > +	}
> 
> The above error message is unnecessary because fsverity_verify_signature()
> already prints an error message on failure.
> 
> > +
> > +	err = security_inode_setsecurity(inode, FS_VERITY_INODE_SEC_NAME, desc->signature,
> > +					 le32_to_cpu(desc->sig_size), 0);
> 
> This runs even if CONFIG_FS_VERITY_BUILTIN_SIGNATURES is disabled.  Is that
> really the right behavior?
> 
Yes the hook call should better depend on a KCONFIG. After second thought I think it
should depend on CONFIG_IPE_PROP_FS_VERITY, which also indirectly introduces the
dependency on CONFIG_FS_VERITY_BUILTIN_SIGNATURES.

Currently security_inode_setsecurity only allows one LSM to save data with a given name.
In our case IPE will be the only LSM that saves the signature.

I will update this part in the next version.

> Also a nit: please stick to the preferred line length of 80 characters.
> See Documentation/process/coding-style.rst
> 
> > diff --git a/fs/verity/signature.c b/fs/verity/signature.c
> > index 143a530a8008..5d7b9496f9c4 100644
> > --- a/fs/verity/signature.c
> > +++ b/fs/verity/signature.c
> > @@ -9,6 +9,7 @@
> >  
> >  #include <linux/cred.h>
> >  #include <linux/key.h>
> > +#include <linux/security.h>
> >  #include <linux/slab.h>
> >  #include <linux/verification.h>
> 
> This change is unnecessary.
> 
> > diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
> > index 40f14e5fed9d..29e9888287ba 100644
> > --- a/include/linux/fsverity.h
> > +++ b/include/linux/fsverity.h
> > @@ -254,4 +254,6 @@ static inline bool fsverity_active(const struct inode *inode)
> >  	return fsverity_get_info(inode) != NULL;
> >  }
> >  
> > +#define FS_VERITY_INODE_SEC_NAME "fsverity.inode-info"
> 
> "inode-info" is very vague.  Shouldn't it be named "builtin-sig" or something?
> 
> - Eric

I agree this name works better, I will change it to "fsverity.builtin-sig".
-Fan
