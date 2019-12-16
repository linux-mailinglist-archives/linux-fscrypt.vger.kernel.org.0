Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52626121EB6
	for <lists+linux-fscrypt@lfdr.de>; Tue, 17 Dec 2019 00:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfLPXHF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 16 Dec 2019 18:07:05 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:55372 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726487AbfLPXHF (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 16 Dec 2019 18:07:05 -0500
Received: from callcc.thunk.org (guestnat-104-133-0-111.corp.google.com [104.133.0.111] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id xBGN70fm018848
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Dec 2019 18:07:00 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id C64B5420821; Mon, 16 Dec 2019 18:06:59 -0500 (EST)
Date:   Mon, 16 Dec 2019 18:06:59 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [xfstests-bld PATCH] kernel-configs: enable CONFIG_CRYPTO_ESSIV
 in 5.4 configs
Message-ID: <20191216230659.GC785904@mit.edu>
References: <20191202232340.243744-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202232340.243744-1-ebiggers@kernel.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Dec 02, 2019 at 03:23:40PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> On kernel 5.5 and later, CONFIG_CRYPTO_ESSIV is needed for one of the
> fscrypt tests (generic/549) to run.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

						- Ted
