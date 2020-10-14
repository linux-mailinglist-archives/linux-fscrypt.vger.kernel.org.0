Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26FAD28E898
	for <lists+linux-fscrypt@lfdr.de>; Thu, 15 Oct 2020 00:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgJNV75 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 14 Oct 2020 17:59:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbgJNV75 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 14 Oct 2020 17:59:57 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33D4F22247;
        Wed, 14 Oct 2020 21:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602712796;
        bh=DJdDJENYR2Cze0UMyRfXq0e6q6ji3HcG/j0k64HCap0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lFfftQfuCb5fFBFNzePWrJirniJ29aGqxHJr3XHD/xFx/G1IBQbfnTq+yWXGt9vtD
         sS8Ft1M74Fka6y7XVcOoABnipmFlByEjOr2/gcZHn+9ix6iUktNEB72blz2rzLgZ8d
         pbXO75CmajUJMCGNt6ED23jy7W4Y0Lr8wd/r1P4M=
Date:   Wed, 14 Oct 2020 14:59:54 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 35/80] docs: fs: fscrypt.rst: get rid of :c:type: tags
Message-ID: <20201014215954.GB2545693@gmail.com>
References: <cover.1602589096.git.mchehab+huawei@kernel.org>
 <2ca36d4903a6c024c7605cd58eab417c8e5296b5.1602589096.git.mchehab+huawei@kernel.org>
 <20201013172512.GA1306858@gmail.com>
 <20201014085907.7da5bed3@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201014085907.7da5bed3@coco.lan>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Oct 14, 2020 at 08:59:07AM +0200, Mauro Carvalho Chehab wrote:
> [PATCH v6.1 35/80] docs: fs: fscrypt.rst: get rid of :c:type: tags
> 
> The :c:type: tag has problems with Sphinx 3.x, as structs
> there should be declared with c:struct.
> 
> So, remove them, relying at automarkup.py extension to
> convert them into cross-references.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

"relying at" => "relying on".

Otherwise looks fine, you can add:

Reviewed-by: Eric Biggers <ebiggers@google.com>

I do still wonder about your comment though:

> It should be said that, currently, if there's no documentation for "foo",
> automarkup will just keep using the regular text font, keeping the text
> untouched.

That will apply to most (maybe all) of the structures mentioned in this file.
I expected that if the documentation system now automatically recognizes
'struct foo', then it would render it in code font even when 'struct foo' isn't
documented.  Any particular reason why that isn't the case?  Not like I care
much myself, but it's a bit unexpected and it means this change actually makes
the rendered documentation look worse...

- Eric
