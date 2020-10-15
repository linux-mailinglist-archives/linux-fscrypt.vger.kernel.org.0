Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9646B28ECAD
	for <lists+linux-fscrypt@lfdr.de>; Thu, 15 Oct 2020 07:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgJOFcN (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 15 Oct 2020 01:32:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbgJOFcN (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 15 Oct 2020 01:32:13 -0400
Received: from coco.lan (ip5f5ad5a1.dynamic.kabel-deutschland.de [95.90.213.161])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD27922247;
        Thu, 15 Oct 2020 05:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602739932;
        bh=tvTGnLhwyWTmpxEH0NnPzvKJR5lhY8hgxX9pTfDeJ7Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dOSxk4aSmgDgsx8kagXkXRcCPJbWMKyZNP8hTxYjqwgvfcr3x9h4N4ao6ekx1vw+5
         cutUKSs1B2RbWfYgSC/kksDS3vPvbDhni8FcWbKfz8c7Ym9usMp4XTMwjQ4XGx7LlX
         tNz/SwjvRAw48vIpXa1RTua8RfsYLYN+ivWThV34=
Date:   Thu, 15 Oct 2020 07:32:07 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 35/80] docs: fs: fscrypt.rst: get rid of :c:type:
 tags
Message-ID: <20201015073207.7504a55b@coco.lan>
In-Reply-To: <20201014215954.GB2545693@gmail.com>
References: <cover.1602589096.git.mchehab+huawei@kernel.org>
        <2ca36d4903a6c024c7605cd58eab417c8e5296b5.1602589096.git.mchehab+huawei@kernel.org>
        <20201013172512.GA1306858@gmail.com>
        <20201014085907.7da5bed3@coco.lan>
        <20201014215954.GB2545693@gmail.com>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Em Wed, 14 Oct 2020 14:59:54 -0700
Eric Biggers <ebiggers@kernel.org> escreveu:

> On Wed, Oct 14, 2020 at 08:59:07AM +0200, Mauro Carvalho Chehab wrote:
> > [PATCH v6.1 35/80] docs: fs: fscrypt.rst: get rid of :c:type: tags
> > 
> > The :c:type: tag has problems with Sphinx 3.x, as structs
> > there should be declared with c:struct.
> > 
> > So, remove them, relying at automarkup.py extension to
> > convert them into cross-references.
> >
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>  
> 
> "relying at" => "relying on".
> 
> Otherwise looks fine, you can add:
> 
> Reviewed-by: Eric Biggers <ebiggers@google.com>

Thank you for reviewing it!

> I do still wonder about your comment though:
> 
> > It should be said that, currently, if there's no documentation for "foo",
> > automarkup will just keep using the regular text font, keeping the text
> > untouched.  
> 
> That will apply to most (maybe all) of the structures mentioned in this file.
> I expected that if the documentation system now automatically recognizes
> 'struct foo', then it would render it in code font even when 'struct foo' isn't
> documented.  Any particular reason why that isn't the case?  Not like I care
> much myself, but it's a bit unexpected and it means this change actually makes
> the rendered documentation look worse...

Yeah, I agree that using monospaced fonts on this case too would
be nice. The C domain actually uses italic monospaced fonts for
broken XREFs.

I suspect that changing this at automarkup.py would be simple, but
not sure if it would be safe.

Jon can tell more about that, as he's the author of automarkup,
but I suspect that the reason for the current behavior is to avoid 
false-positives. 

I mean, if "struct foo" symbol doesn't exist at the C domain, this
might mean that the parser is doing something wrong. So, a more
conservative approach is to keep the string as-is.

On the other hand, if one finds a valid "struct foo" using normal
fonts, this would mean that either the doc is outdated, mentioning
an struct that were removed/renamed or that there's a missing 
kernel-doc markup.

In any case, the fix is to simply fix the kernel-doc markup for
struct foo.

I guess in the future automarkup.py could issue a warning in
order to warn about missing cross-references, perhaps when
W=1 or W=2 is used.

Thanks,
Mauro
