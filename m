Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A051D03F7
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2020 02:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729215AbgEMAyO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 12 May 2020 20:54:14 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:55794 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726031AbgEMAyN (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 12 May 2020 20:54:13 -0400
Received: from callcc.thunk.org (pool-100-0-195-244.bstnma.fios.verizon.net [100.0.195.244])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 04D0rtem000396
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 May 2020 20:53:55 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 23FCB4202E4; Tue, 12 May 2020 20:53:55 -0400 (EDT)
Date:   Tue, 12 May 2020 20:53:55 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Daniel Rosenberg <drosen@google.com>
Subject: Re: [PATCH 1/4] linux/parser.h: add include guards
Message-ID: <20200513005355.GE1596452@mit.edu>
References: <20200512233251.118314-1-ebiggers@kernel.org>
 <20200512233251.118314-2-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512233251.118314-2-ebiggers@kernel.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, May 12, 2020 at 04:32:48PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> <linux/parser.h> is missing include guards.  Add them.
> 
> This is needed to allow declaring a function in <linux/fscrypt.h> that
> takes a substring_t parameter.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Theodore Ts'o <tytso@mit.edu>
