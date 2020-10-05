Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADA5828355B
	for <lists+linux-fscrypt@lfdr.de>; Mon,  5 Oct 2020 14:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbgJEMG3 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 5 Oct 2020 08:06:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgJEMG2 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 5 Oct 2020 08:06:28 -0400
Received: from coco.lan (ip5f5ad5d6.dynamic.kabel-deutschland.de [95.90.213.214])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E7882075A;
        Mon,  5 Oct 2020 12:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601899587;
        bh=calSC86nxnRZayzM+fSWlEyXNmfxDUtQSyrvMVMYC0s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aUn6iRTgb/p6UI+FI1CHDbAIH+GO8Q6/p7Ud9d43JOk3wFlM3AbPpopAFjI3jICyk
         UBm1Ms6O4vK3FzHKJlZv5Sp/mowa7y3J3dFW3w/OPY+xOhABJhnuJ7LoM6f9l3Fu6G
         9yIm//0Xy3ZCB6wKgxmJrspYBQF3zYITOw4TCtYc=
Date:   Mon, 5 Oct 2020 14:06:22 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 35/52] docs: fs: fscrypt.rst: get rid of :c:type:
 tags
Message-ID: <20201005140622.50693933@coco.lan>
In-Reply-To: <20200930170637.GB9698@sol.localdomain>
References: <cover.1601467849.git.mchehab+huawei@kernel.org>
        <689d790237b64fc7d81fcf97ac303cc1dbdd33d4.1601467849.git.mchehab+huawei@kernel.org>
        <20200930162144.GA9698@sol.localdomain>
        <20200930185333.66dacbc6@coco.lan>
        <20200930170637.GB9698@sol.localdomain>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Eric,

Em Wed, 30 Sep 2020 10:06:37 -0700
Eric Biggers <ebiggers@kernel.org> escreveu:

> > I double checked: it is against next-20200922. The reason of
> > not being today's next is that I didn't want any new warnings
> > to be introduced before I finish this patch series.
> > 
> > Anyway, I'm planning to do a rebase tomorrow on the top of the 
> > latest -next.
> >   
> 
> Doesn't work.  Here's what I did:

...

> Cover: ./v4_20200930_mchehab_huawei_fix_html_build_with_sphinx_3_1_and_above.cover
>  Link: https://lore.kernel.org/r/cover.1601467849.git.mchehab+huawei@kernel.org
>  Base: not found
>        git am ./v4_20200930_mchehab_huawei_fix_html_build_with_sphinx_3_1_and_above.mbx
> 
> e@sol ~/linux $ git am ./v4_20200930_mchehab_huawei_fix_html_build_with_sphinx_3_1_and_above.mbx
> Applying: docs: cdomain.py: add support for a new Sphinx 3.1+ tag
> Applying: docs: cdomain.py: extend it to handle new Sphinx 3.x tags
> Applying: docs: conf.py: disable automarkup for Sphinx 3.x
> Applying: scripts: kernel-doc: make it more compatible with Sphinx 3.x
> Applying: scripts: kernel-doc: use a less pedantic markup for funcs on Sphinx 3.x
> Applying: scripts: kernel-doc: fix troubles with line counts
> Applying: scripts: kernel-doc: reimplement -nofunction argument
> Applying: scripts: kernel-doc: fix typedef identification
> Applying: scripts: kernel-doc: don't mangle with parameter list
> Applying: docs: kerneldoc.py: append the name of the parsed doc file
> Applying: docs: kerneldoc.py: add support for kerneldoc -nosymbol
> Applying: media: docs: make CEC documents compatible with Sphinx 3.1+
> Applying: media: docs: make V4L documents more compatible with Sphinx 3.1+
> error: patch failed: Documentation/userspace-api/media/v4l/hist-v4l2.rst:202
> error: Documentation/userspace-api/media/v4l/hist-v4l2.rst: patch does not apply
> error: patch failed: Documentation/userspace-api/media/v4l/vidioc-enum-fmt.rst:227
> error: Documentation/userspace-api/media/v4l/vidioc-enum-fmt.rst: patch does not apply
> Patch failed at 0013 media: docs: make V4L documents more compatible with Sphinx 3.1+
> hint: Use 'git am --show-current-patch=diff' to see the failed patch
> When you have resolved this problem, run "git am --continue".
> If you prefer to skip this patch, run "git am --skip" instead.
> To restore the original branch and stop patching, run "git am --abort".

Well, the media patches were indeed based at the media upstream tree.
As I maintain the media tree, and the changes for it are huge, I opted
to merge from media before applying this series. Btw, the series
is also after the other fix patches for the warnings with Sphinx 2.x 
that I sent previously. It might eventually conflict with the Sphinx 3.x
patch series.

At the current version, there are 101 patches against next-20201002, being
about half of them fixing all doc warnings on Sphinx 2.x, and the other 
ones fixing almost all Sphinx 3.x warnings.

The latest version at:

	https://git.linuxtv.org/mchehab/experimental.git/log/?h=sphinx3-fixes-v4

In the specific case of fscript.rst, there are only two patches on my
series affecting it, both as part of this /52 series:

	$ git log next-20200922..devel/sphinx3-fixes-v4 Documentation/filesystems/fscrypt.rst
	commit ee4af6dd20dd6d2ac7f5d970abac960a36679e13
	Author: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
	Date:   Tue Sep 29 09:13:18 2020 +0200

	    docs: fs: fscrypt.rst: get rid of :c:type: tags
    
	    The :c:type: tag has problems with Sphinx 3.x, as structs
	    there should be declared with c:struct.
    
	    So, remove them, relying at automarkup.py extension to
	    convert them into cross-references.
    
	    Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

	commit 0945e3961d006e210e374b6d3224d9108c1dfa25
	Author: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
	Date:   Fri Sep 25 12:01:25 2020 +0200

	    docs: get rid of :c:type explicit declarations for structs
    
	    The :c:type:`foo` only works properly with structs before
	    Sphinx 3.x.
    
	    On Sphinx 3.x, structs should now be declared using the
	    .. c:struct, and referenced via :c:struct tag.
    
	    As we now have the automarkup.py macro, that automatically
	    convert:
        	    struct foo
    
	    into cross-references, let's get rid of that, solving
	    several warnings when building docs with Sphinx 3.x.
    
	    Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Anyway, I'm waiting for the today's next, in order to do another
rebase, fixing any new warning that might be added, and to post the
patches that weren't merged yet via other trees.

The end goal is to have zero warnings with Sphinx 2.x, and the minimal
number of warnings with 3.x (right now, there's just 6 warnings
with 3.x - fixing those require fixes at Sphinx C domain parser).

Thanks,
Mauro
