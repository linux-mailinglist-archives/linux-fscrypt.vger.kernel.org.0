Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F59827EAE8
	for <lists+linux-fscrypt@lfdr.de>; Wed, 30 Sep 2020 16:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730554AbgI3O0g (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 30 Sep 2020 10:26:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730231AbgI3O0g (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 30 Sep 2020 10:26:36 -0400
Received: from kernel.org (unknown [87.71.73.56])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FE0F20754;
        Wed, 30 Sep 2020 14:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601475995;
        bh=Fl0gWvmfXmejHi4EkMTsQTZGLiXma9CtfTHw7weRdJQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KjiTNGFe5eTBdlXhF/NHplwtol5FYNLNxilPqKQv6JM7qzFpC1oscmHw8w7JZ6bPS
         DMKgScFLDkfuKtoCeOjffSJqprhEpbZkmUsXsiby6BhkBtcft1Fr0y1KDRK6Jmh86a
         QzcATOFg5nZHWWzlf7PwQmBO1ehMJBH5Itwvqrpk=
Date:   Wed, 30 Sep 2020 17:26:24 +0300
From:   Mike Rapoport <rppt@kernel.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "Alexander A. Klimov" <grandmaster@al2klimov.de>,
        =?iso-8859-1?Q?Andr=E9?= Almeida <andrealmeid@collabora.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Moritz Fischer <mdf@kernel.org>,
        Puranjay Mohan <puranjay12@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Satya Tangirala <satyat@google.com>,
        Takashi Iwai <tiwai@suse.com>, Tom Rix <trix@redhat.com>,
        alsa-devel@alsa-project.org, linux-fpga@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 22/52] docs: get rid of :c:type explicit declarations
 for structs
Message-ID: <20200930142624.GM2142832@kernel.org>
References: <cover.1601467849.git.mchehab+huawei@kernel.org>
 <f74a2b4e1c8c475b5a053f5edd9da5a818be4b1f.1601467849.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f74a2b4e1c8c475b5a053f5edd9da5a818be4b1f.1601467849.git.mchehab+huawei@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Sep 30, 2020 at 03:24:45PM +0200, Mauro Carvalho Chehab wrote:
> The :c:type:`foo` only works properly with structs before
> Sphinx 3.x.
> 
> On Sphinx 3.x, structs should now be declared using the
> .. c:struct, and referenced via :c:struct tag.
> 
> As we now have the automarkup.py macro, that automatically
> convert:
> 	struct foo
> 
> into cross-references, let's get rid of that, solving
> several warnings when building docs with Sphinx 3.x.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
...
>  Documentation/vm/ksm.rst                      |  2 +-
>  Documentation/vm/memory-model.rst             |  6 ++---
>  mm/ksm.c                                      |  2 +-
>  mm/memblock.c                                 |  4 ++--

Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>

>  30 files changed, 93 insertions(+), 93 deletions(-)
> 
