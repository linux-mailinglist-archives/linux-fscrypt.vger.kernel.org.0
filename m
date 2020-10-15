Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6EED28FAA2
	for <lists+linux-fscrypt@lfdr.de>; Thu, 15 Oct 2020 23:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730587AbgJOV0K (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 15 Oct 2020 17:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730453AbgJOV0I (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 15 Oct 2020 17:26:08 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6281C061755
        for <linux-fscrypt@vger.kernel.org>; Thu, 15 Oct 2020 14:26:07 -0700 (PDT)
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 073C8739;
        Thu, 15 Oct 2020 21:26:05 +0000 (UTC)
Date:   Thu, 15 Oct 2020 15:26:03 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 35/80] docs: fs: fscrypt.rst: get rid of :c:type:
 tags
Message-ID: <20201015152603.6b2c40cd@lwn.net>
In-Reply-To: <20201015073207.7504a55b@coco.lan>
References: <cover.1602589096.git.mchehab+huawei@kernel.org>
        <2ca36d4903a6c024c7605cd58eab417c8e5296b5.1602589096.git.mchehab+huawei@kernel.org>
        <20201013172512.GA1306858@gmail.com>
        <20201014085907.7da5bed3@coco.lan>
        <20201014215954.GB2545693@gmail.com>
        <20201015073207.7504a55b@coco.lan>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, 15 Oct 2020 07:32:07 +0200
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> > That will apply to most (maybe all) of the structures mentioned in this file.
> > I expected that if the documentation system now automatically recognizes
> > 'struct foo', then it would render it in code font even when 'struct foo' isn't
> > documented.  Any particular reason why that isn't the case?  Not like I care
> > much myself, but it's a bit unexpected and it means this change actually makes
> > the rendered documentation look worse...  
> 
> Yeah, I agree that using monospaced fonts on this case too would
> be nice. The C domain actually uses italic monospaced fonts for
> broken XREFs.
> 
> I suspect that changing this at automarkup.py would be simple, but
> not sure if it would be safe.
> 
> Jon can tell more about that, as he's the author of automarkup,
> but I suspect that the reason for the current behavior is to avoid 
> false-positives. 

Automarkup has always behaved that way because ... well, because nobody
got around to changing it.  I don't see any reason not to use a monospace
font for such things, just without a link; shouldn't be a problem to do.
I'll see if I can't get to it once things stabilize a bit.

Thanks,

jon
