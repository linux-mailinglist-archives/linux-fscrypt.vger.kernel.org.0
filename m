Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE49128F747
	for <lists+linux-fscrypt@lfdr.de>; Thu, 15 Oct 2020 18:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389479AbgJOQ5I (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 15 Oct 2020 12:57:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:35110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730793AbgJOQ5I (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 15 Oct 2020 12:57:08 -0400
Received: from coco.lan (ip5f5ad5a1.dynamic.kabel-deutschland.de [95.90.213.161])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 810C0206CA;
        Thu, 15 Oct 2020 16:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602781027;
        bh=aZSJUmlfGw8r58Z5k8FZPhCBso0fzX2STY7EVtJw6bk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GXqfHhMIw67eZuC8cjyZDpvo1I7LJO9dI7Ci6vdF2Sbe7YSbMQs2ri5nSt6iEaWpS
         9vrJB/5kqdotgvB7NRRa/5SU7Pi9v1hfz/E+6jiNewXeAMyRqcesVICahT8dyK4eXT
         lIG8cSW/ZOtdPIGFaBETtkP5al2mRDt1JNJJ+OWc=
Date:   Thu, 15 Oct 2020 18:56:58 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 35/80] docs: fs: fscrypt.rst: get rid of :c:type:
 tags
Message-ID: <20201015185658.5778544e@coco.lan>
In-Reply-To: <20201015163605.GA3336735@gmail.com>
References: <cover.1602589096.git.mchehab+huawei@kernel.org>
        <2ca36d4903a6c024c7605cd58eab417c8e5296b5.1602589096.git.mchehab+huawei@kernel.org>
        <20201013172512.GA1306858@gmail.com>
        <20201014085907.7da5bed3@coco.lan>
        <20201014215954.GB2545693@gmail.com>
        <20201015073207.7504a55b@coco.lan>
        <20201015163605.GA3336735@gmail.com>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Em Thu, 15 Oct 2020 09:36:05 -0700
Eric Biggers <ebiggers@kernel.org> escreveu:

> On Thu, Oct 15, 2020 at 07:32:07AM +0200, Mauro Carvalho Chehab wrote:
> > On the other hand, if one finds a valid "struct foo" using normal
> > fonts, this would mean that either the doc is outdated, mentioning
> > an struct that were removed/renamed or that there's a missing 
> > kernel-doc markup.
> > 
> > In any case, the fix is to simply fix the kernel-doc markup for
> > struct foo.
> > 
> > I guess in the future automarkup.py could issue a warning in
> > order to warn about missing cross-references, perhaps when
> > W=1 or W=2 is used.  
> 
> Well, most structs that fscrypt.rst refers to are defined in
> include/uapi/linux/fscrypt.h.  The whole fscrypt UAPI, including the fields of
> these structs, is documented in fscrypt.rst.  So I didn't really intend the
> fscrypt UAPI structs to have kerneldoc comments, as people are supposed to refer
> to the documentation in fscrypt.rst instead.  We could have both, but it feels a
> bit redundant.

Yeah, we do the same on V4L: the uAPI doesn't use kernel-docs. It is
documented, instead, at ReST files.

In any case, if all structs are documented, automarkup should
be using monospaced fonts and be generating cross-references.

If not, the regular expressions there may need tweaks ;-)

Thanks,
Mauro
