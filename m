Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F03B727EFA2
	for <lists+linux-fscrypt@lfdr.de>; Wed, 30 Sep 2020 18:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730897AbgI3Qu7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 30 Sep 2020 12:50:59 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:51136 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI3Qu7 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 30 Sep 2020 12:50:59 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: tonyk)
        with ESMTPSA id 4FDA729CD77
Subject: Re: [PATCH v4 22/52] docs: get rid of :c:type explicit declarations
 for structs
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>,
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
        Mike Rapoport <rppt@kernel.org>,
        Moritz Fischer <mdf@kernel.org>,
        Puranjay Mohan <puranjay12@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Satya Tangirala <satyat@google.com>,
        Takashi Iwai <tiwai@suse.com>, Tom Rix <trix@redhat.com>,
        alsa-devel@alsa-project.org, linux-fpga@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org
References: <cover.1601467849.git.mchehab+huawei@kernel.org>
 <f74a2b4e1c8c475b5a053f5edd9da5a818be4b1f.1601467849.git.mchehab+huawei@kernel.org>
From:   =?UTF-8?Q?Andr=c3=a9_Almeida?= <andrealmeid@collabora.com>
Message-ID: <fd8bf973-3c22-a492-39e5-2164ce6724db@collabora.com>
Date:   Wed, 30 Sep 2020 13:50:46 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <f74a2b4e1c8c475b5a053f5edd9da5a818be4b1f.1601467849.git.mchehab+huawei@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 9/30/20 10:24 AM, Mauro Carvalho Chehab wrote:
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
>  Documentation/block/blk-mq.rst                |  8 +++----

Regarding blk-mq.rst:

Reviewed-by: André Almeida <andrealmeid@collabora.com>
