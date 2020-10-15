Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9834928F6E2
	for <lists+linux-fscrypt@lfdr.de>; Thu, 15 Oct 2020 18:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389746AbgJOQgI (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 15 Oct 2020 12:36:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389258AbgJOQgI (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 15 Oct 2020 12:36:08 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1601D22210;
        Thu, 15 Oct 2020 16:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602779767;
        bh=yaXOtRmASXSGJpCPGckZbgBc9TUYjmkPJKXlD7mzlXQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IEDd8b3kSmvCKaSQgP32yIf6CUR+HKmU/TuAEhFfi5mJvRx1Kto78pqz2ygBKjAKO
         YsrAcghKR+qxlk5LVKNYYGgcmkYe0ENcQ8rVxJq4VZreo3qZ2G+94DOspCxRrfZxxI
         ka/TwgvBUB4mRc76ob3JkGnIU7yaZtYPxmjXMSSw=
Date:   Thu, 15 Oct 2020 09:36:05 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 35/80] docs: fs: fscrypt.rst: get rid of :c:type: tags
Message-ID: <20201015163605.GA3336735@gmail.com>
References: <cover.1602589096.git.mchehab+huawei@kernel.org>
 <2ca36d4903a6c024c7605cd58eab417c8e5296b5.1602589096.git.mchehab+huawei@kernel.org>
 <20201013172512.GA1306858@gmail.com>
 <20201014085907.7da5bed3@coco.lan>
 <20201014215954.GB2545693@gmail.com>
 <20201015073207.7504a55b@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015073207.7504a55b@coco.lan>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Oct 15, 2020 at 07:32:07AM +0200, Mauro Carvalho Chehab wrote:
> On the other hand, if one finds a valid "struct foo" using normal
> fonts, this would mean that either the doc is outdated, mentioning
> an struct that were removed/renamed or that there's a missing 
> kernel-doc markup.
> 
> In any case, the fix is to simply fix the kernel-doc markup for
> struct foo.
> 
> I guess in the future automarkup.py could issue a warning in
> order to warn about missing cross-references, perhaps when
> W=1 or W=2 is used.

Well, most structs that fscrypt.rst refers to are defined in
include/uapi/linux/fscrypt.h.  The whole fscrypt UAPI, including the fields of
these structs, is documented in fscrypt.rst.  So I didn't really intend the
fscrypt UAPI structs to have kerneldoc comments, as people are supposed to refer
to the documentation in fscrypt.rst instead.  We could have both, but it feels a
bit redundant.

- Eric
