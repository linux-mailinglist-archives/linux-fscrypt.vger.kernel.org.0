Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D247C139A1F
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Jan 2020 20:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgAMTZO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 13 Jan 2020 14:25:14 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:54655 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726435AbgAMTZO (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 13 Jan 2020 14:25:14 -0500
Received: from callcc.thunk.org (guestnat-104-133-0-111.corp.google.com [104.133.0.111] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 00DJP8s5000442
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Jan 2020 14:25:09 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 2EDA64207DF; Mon, 13 Jan 2020 14:25:08 -0500 (EST)
Date:   Mon, 13 Jan 2020 14:25:08 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] ext4: handle decryption error in
 __ext4_block_zero_page_range()
Message-ID: <20200113192508.GH30418@mit.edu>
References: <20191226154105.4704-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191226154105.4704-1-ebiggers@kernel.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Dec 26, 2019 at 09:41:05AM -0600, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> fscrypt_decrypt_pagecache_blocks() can fail, because it uses
> skcipher_request_alloc(), which uses kmalloc(), which can fail; and also
> because it calls crypto_skcipher_decrypt(), which can fail depending on
> the driver that actually implements the crypto.
> 
> Therefore it's not appropriate to WARN on decryption error in
> __ext4_block_zero_page_range().
> 
> Remove the WARN and just handle the error instead.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

					- Ted
