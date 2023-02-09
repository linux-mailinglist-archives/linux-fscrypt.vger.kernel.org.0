Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 014D369139C
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Feb 2023 23:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbjBIWnW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Feb 2023 17:43:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbjBIWnF (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Feb 2023 17:43:05 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 802076A58;
        Thu,  9 Feb 2023 14:42:44 -0800 (PST)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id F1D2D20C8AF3; Thu,  9 Feb 2023 14:42:43 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com F1D2D20C8AF3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1675982564;
        bh=twQrcBPkL//FHJ6DuWZAJcdyzb2KtmPBGq3WDULJ5IA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KS6NUOHT53V1toIWOzZ/B95ebJ5eY0gLTk1eC5rRL0tSXiDlIiuJVvP7SoqvF8jFO
         XYpL69kk1pddbeXiBgrVMfd1Tcxz6KAoUp3onHgeS92LxxFjYFWnPciIXEya1X+2in
         W8cVKwaTHJS1LF3ACYcFE1JjThrIw4QRvKhAwv1w=
Date:   Thu, 9 Feb 2023 14:42:43 -0800
From:   Fan Wu <wufan@linux.microsoft.com>
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>
Cc:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
        axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        eparis@redhat.com, paul@paul-moore.com, linux-doc@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-audit@redhat.com,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [RFC PATCH v9 06/16] ipe: add LSM hooks on execution and kernel
 read
Message-ID: <20230209224243.GA9462@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-7-git-send-email-wufan@linux.microsoft.com>
 <412da9a9da2e75e896911f01bfd735dd4b5789f4.camel@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <412da9a9da2e75e896911f01bfd735dd4b5789f4.camel@huaweicloud.com>
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

On Tue, Jan 31, 2023 at 01:51:39PM +0100, Roberto Sassu wrote:
> On Mon, 2023-01-30 at 14:57 -0800, Fan Wu wrote:
> > +
> > +/**
> > + * ipe_mmap_file - ipe security hook function for mmap check.
> > + * @f: File being mmap'd. Can be NULL in the case of anonymous memory.
> > + * @reqprot: The requested protection on the mmap, passed from usermode.
> > + * @prot: The effective protection on the mmap, resolved from reqprot and
> > + *	  system configuration.
> > + * @flags: Unused.
> > + *
> > + * This hook is called when a file is loaded through the mmap
> > + * family of system calls.
> > + *
> > + * Return:
> > + * * 0	- OK
> > + * * !0	- Error
> > + */
> > +int ipe_mmap_file(struct file *f, unsigned long reqprot, unsigned long prot,
> > +		  unsigned long flags)
> > +{
> > +	struct ipe_eval_ctx ctx = { 0 };
> > +
> > +	if (prot & PROT_EXEC || reqprot & PROT_EXEC) {
> 
> Since the kernel only adds flags and doesn't clear them, isn't safe to
> just consider prot? Oh, you mentioned it in the changelog, maybe just
> for ipe_file_mprotect().
> 

Thanks for pointing that out, yes reqprot it indeed unnecessary, I will remove
this part in the next version. 

> > +		build_eval_ctx(&ctx, f, ipe_op_exec);
> > +		return ipe_evaluate_event(&ctx);
> > +	}
> 
> Uhm, I think some considerations that IMA does for mmap() are relevant
> also for IPE.
> 
> For example, look at mmap_violation_check(). It checks if there are
> writable mappings, and if yes, it denies the access.
> 
> Similarly for mprotect(), is adding PROT_EXEC safe?
> 

Yes, writable mapping might need to treat differently. But for the current version
I think it is safe because currently we only support dmverity and fsverity,
they are inherently read-only.

But if in the future if there is a feature can support writable mapping, IPE might
better provide user the flexibility to allow or deny execute writable mappings,
for example, adding a new property like file_writable=TRUE. Then user can deploy
a rule like op=EXECUTE file_writable=TRUE action=DENY to deny execute a writable
mapping.

> >  
> > @@ -12,6 +13,11 @@ static struct lsm_blob_sizes ipe_blobs __lsm_ro_after_init = {
> >  
> >  static struct security_hook_list ipe_hooks[] __lsm_ro_after_init = {
> >  	LSM_HOOK_INIT(sb_free_security, ipe_sb_free_security),
> > +	LSM_HOOK_INIT(bprm_check_security, ipe_bprm_check_security),
> > +	LSM_HOOK_INIT(mmap_file, ipe_mmap_file),
> > +	LSM_HOOK_INIT(file_mprotect, ipe_file_mprotect),
> > +	LSM_HOOK_INIT(kernel_read_file, ipe_kernel_read_file),
> > +	LSM_HOOK_INIT(kernel_load_data, ipe_kernel_load_data),
> >  };
> 
> Uhm, maybe I would incorporate patch 1 with this.
> 
> Roberto

This might not be possible because this patch has some dependencies on the previous patches.
-Fan
