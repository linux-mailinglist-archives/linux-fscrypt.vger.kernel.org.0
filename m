Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF568139A3F
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Jan 2020 20:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728668AbgAMTfA (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 13 Jan 2020 14:35:00 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:56766 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728641AbgAMTe7 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 13 Jan 2020 14:34:59 -0500
Received: from callcc.thunk.org (guestnat-104-133-0-111.corp.google.com [104.133.0.111] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 00DJYtsk005012
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Jan 2020 14:34:56 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id F30864207DF; Mon, 13 Jan 2020 14:34:54 -0500 (EST)
Date:   Mon, 13 Jan 2020 14:34:54 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] ext4: only use fscrypt_zeroout_range() on regular files
Message-ID: <20200113193454.GC76141@mit.edu>
References: <20191226161022.53490-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191226161022.53490-1-ebiggers@kernel.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Dec 26, 2019 at 10:10:22AM -0600, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> fscrypt_zeroout_range() is only for encrypted regular files, not for
> encrypted directories or symlinks.
> 
> Fortunately, currently it seems it's never called on non-regular files.
> But to be safe ext4 should explicitly check S_ISREG() before calling it.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

					- Ted
