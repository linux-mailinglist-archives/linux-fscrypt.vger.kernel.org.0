Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B0C27EFB6
	for <lists+linux-fscrypt@lfdr.de>; Wed, 30 Sep 2020 18:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgI3Qxl (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 30 Sep 2020 12:53:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgI3Qxl (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 30 Sep 2020 12:53:41 -0400
Received: from coco.lan (ip5f5ad5c4.dynamic.kabel-deutschland.de [95.90.213.196])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7A61206C9;
        Wed, 30 Sep 2020 16:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601484820;
        bh=vgVUIlG7y38aRzlS6n0BPP7/G3xv32Hc8nNsbwsIFmc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=crl6lfwOvUoJAnZ50uuBAoxi/KycpQsgAXMReSxZDwjxyBxbTUpTE9hJN42vMJWgd
         t5hu40BI+cpabnB1UJJ1M7tGQVvbjMaE3sDb5gWePVO8qg1B8jCc/Som4CCuio9Qis
         ImFECauc6imKojeHO5/KwkHth/abZCMkyaN9P+fE=
Date:   Wed, 30 Sep 2020 18:53:33 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 35/52] docs: fs: fscrypt.rst: get rid of :c:type:
 tags
Message-ID: <20200930185333.66dacbc6@coco.lan>
In-Reply-To: <20200930162144.GA9698@sol.localdomain>
References: <cover.1601467849.git.mchehab+huawei@kernel.org>
        <689d790237b64fc7d81fcf97ac303cc1dbdd33d4.1601467849.git.mchehab+huawei@kernel.org>
        <20200930162144.GA9698@sol.localdomain>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Eric,

Em Wed, 30 Sep 2020 09:21:44 -0700
Eric Biggers <ebiggers@kernel.org> escreveu:

> On Wed, Sep 30, 2020 at 03:24:58PM +0200, Mauro Carvalho Chehab wrote:
> > The :c:type: tag has problems with Sphinx 3.x, as structs
> > there should be declared with c:struct.
> > 
> > So, remove them, relying at automarkup.py extension to
> > convert them into cross-references.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>  
> 
> What does this patch series apply to?  Cover letter says next-20200922, but it
> doesn't apply.
> 
> It's very difficult to review patches without any way to apply them.

I double checked: it is against next-20200922. The reason of
not being today's next is that I didn't want any new warnings
to be introduced before I finish this patch series.

Anyway, I'm planning to do a rebase tomorrow on the top of the 
latest -next.

Thanks,
Mauro
