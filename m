Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB36A1D8DDA
	for <lists+linux-fscrypt@lfdr.de>; Tue, 19 May 2020 04:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgESCzm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 18 May 2020 22:55:42 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:55455 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726525AbgESCzl (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 18 May 2020 22:55:41 -0400
Received: from callcc.thunk.org (pool-100-0-195-244.bstnma.fios.verizon.net [100.0.195.244])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 04J2tP18003627
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 May 2020 22:55:26 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 84C8B420304; Mon, 18 May 2020 22:55:25 -0400 (EDT)
Date:   Mon, 18 May 2020 22:55:25 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Daniel Rosenberg <drosen@google.com>
Subject: Re: [PATCH 4/4] fscrypt: make test_dummy_encryption use v2 by default
Message-ID: <20200519025525.GD2396055@mit.edu>
References: <20200512233251.118314-1-ebiggers@kernel.org>
 <20200512233251.118314-5-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512233251.118314-5-ebiggers@kernel.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, May 12, 2020 at 04:32:51PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Since v1 encryption policies are deprecated, make test_dummy_encryption
> test v2 policies by default.
> 
> Note that this causes ext4/023 and ext4/028 to start failing due to
> known bugs in those tests (see previous commit).
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Signed-off-by: Theodore Ts'o <tytso@mit.edu>

					- Ted
