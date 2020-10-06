Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB1F28500E
	for <lists+linux-fscrypt@lfdr.de>; Tue,  6 Oct 2020 18:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbgJFQlI (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 6 Oct 2020 12:41:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725902AbgJFQlI (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 6 Oct 2020 12:41:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18F01206D4;
        Tue,  6 Oct 2020 16:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602002466;
        bh=rDLLCAfcpbKWcjiDraDDSN94bLOF55Woeg1qUpEpZss=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1XMM2DnEL0suZYEsKoQ4gvHK221+DNjzTkhDb/jC68bGBPrpJ47KmZGY2Dhmaz9XA
         FTLdSzUXsJbqwg5/8kCi8kMUuiG2QmvADxuduTSykB/Dd179CGtmxw8jo2YYzEa+GA
         608bhe780TJ8H8CeosB+67BzvasTbDhIVpDDq1Oc=
Date:   Tue, 6 Oct 2020 18:41:52 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mike Rapoport <rppt@kernel.org>,
        Moritz Fischer <mdf@kernel.org>,
        Puranjay Mohan <puranjay12@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Satya Tangirala <satyat@google.com>,
        Takashi Iwai <tiwai@suse.com>, Tom Rix <trix@redhat.com>,
        alsa-devel@alsa-project.org, linux-fpga@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        Takashi Iwai <tiwai@suse.de>,
        Mike Rapoport <rppt@linux.ibm.com>
Subject: Re: [PATCH v5 22/52] docs: get rid of :c:type explicit declarations
 for structs
Message-ID: <20201006164152.GB36638@kroah.com>
References: <cover.1601992016.git.mchehab+huawei@kernel.org>
 <1f9d7dfd5e8557b55218af01045331939f1add28.1601992016.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1f9d7dfd5e8557b55218af01045331939f1add28.1601992016.git.mchehab+huawei@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Oct 06, 2020 at 04:03:19PM +0200, Mauro Carvalho Chehab wrote:
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
> Reviewed-by: André Almeida <andrealmeid@collabora.com> # blk-mq.rst
> Reviewed-by: Takashi Iwai <tiwai@suse.de> # sound
> Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
