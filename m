Return-Path: <linux-fscrypt+bounces-1076-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SJ/4BrVXeGkNpgEAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1076-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Tue, 27 Jan 2026 07:14:13 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 69A9C904BF
	for <lists+linux-fscrypt@lfdr.de>; Tue, 27 Jan 2026 07:14:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6D0B23013D75
	for <lists+linux-fscrypt@lfdr.de>; Tue, 27 Jan 2026 06:10:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBAEC329E5C;
	Tue, 27 Jan 2026 06:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bK0h01an"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pl1-f193.google.com (mail-pl1-f193.google.com [209.85.214.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA44E2FD69E
	for <linux-fscrypt@vger.kernel.org>; Tue, 27 Jan 2026 06:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769494252; cv=none; b=fhkeZsR8LsZWRQ3rWntwY1tY//aMVE/hBQLdM162lkmjOVD5B4l/DZh9ektb0HRKCFcht4jMksSjQ+9HA24VqI9YVT8Rkj0RtNwpNYM4j5mEl1AHH0SG4WdpByXHXG6aRmnLxj+oSbt4BPhKfZjC8tdfAlslJp67Yq452HkjyXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769494252; c=relaxed/simple;
	bh=tudOqFY10hNAINi7tYwwway96W0Iri10KO84x+EWVWk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Q+wx1pLIxd136nDAqcITNoBDT5Pg90U5z0YQXrEadnl2jyKj+4V0//cByYJAI3bzm5+tEnC122FQWn+AMURmCjHhCNJRyxg2Vg6pmWs/C0/Ok3wAg8Tq0wFakEHWNBhJwO2g3FcIZXZY6ZcYrSHXC+m2VZ7DC6JOuLS0hSnMVlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bK0h01an; arc=none smtp.client-ip=209.85.214.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f193.google.com with SMTP id d9443c01a7336-29f30233d8aso35568675ad.0
        for <linux-fscrypt@vger.kernel.org>; Mon, 26 Jan 2026 22:10:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769494251; x=1770099051; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qfYQakyv0wbvKi/4iI5cyERiwz/HBfH1fzLY4KZz8F0=;
        b=bK0h01anzZJ0dMwXA6MiQ6els/DZMo9z9UZEUpN1ylFuzVb0lJEUe5PFIiqsT/2isR
         YGrVv9lLkpu+c7dxZcuzxR/OMF/r5qaiDKTPpZjW45GAmn3ngcuVzjtjTUDKgbo+Lavy
         g9n5EVSiQ0JGLu1n98zDqN7vaduBnLp8WrczgcsVbRdcpyUhvlA5uEU/oWVV70z57wZB
         BNs+J9baNYBB0nSY3hTtJtq1B+taTGPDxEqHnK+A4EqP66o4nsVpLGamXu7f1n2kJWZg
         gl4A8K8TlfOSMEWG3H+sIWqsviWoLyr4QRfl52mdiZk2mK9oBedILlWQBCIqMs2JuPJy
         d0qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769494251; x=1770099051;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qfYQakyv0wbvKi/4iI5cyERiwz/HBfH1fzLY4KZz8F0=;
        b=xMouoCgTWUyaLSuTX3i87AJWhvHe1SoQB1T/+b3NB7xlYlWULjummKtTMmz+BYkznX
         SC4krkSm6zXb/E28aG3qoUZvWmDqS8FrZGd9i/SVoybS9pOyskZ9qloA1fC+wb0kvLnU
         FxlY0fl4uXfOag2effU1h2CU/jM2dNUGTgKlz0g4f1r2Xr9r763ZFHxt7wsHcuf488aQ
         /RGJuu4N4NqdozrW8ICLsRYRyxh/6pMI0/YyPjgSGCwMcz68iw6AOAIBTjg8yNWacbRf
         cGnw3xvW8xqeMCAQkCyifYr9ZpkiEDFzZmyObQNJetJS5OJoen3u68/+VSQKF1BAyQpO
         CaRA==
X-Forwarded-Encrypted: i=1; AJvYcCUFHQknLVvM54nC7xBsWR9yzrqBG7RQPR026cKvKR/CJoqws0ETUsOcmBiW8GC+r/egJKawZTJV/tUc52YP@vger.kernel.org
X-Gm-Message-State: AOJu0YzW4VsogcxeTdEvkLEcKRJRXegr87qhmGRYM2+giu+VCWXGbvZw
	hW1/7xYHGlQJTmqODbQQIxQKjgJgbxNE8UMcCv4q5Hc7tIPMc8b0WhF0
X-Gm-Gg: AZuq6aJ/XdfmSmCywG0DHDtc9AqbEV/N6Tx+xgtKrutALF/hwBsIHNObnBnO+AoR6TH
	lKMRM2IHeSmMUySH3ynnRM3UkhdmdZVbYr5HVkOgKCPh3uTUb8WNOX/VVXIXszqhRS/IXcjb5Os
	3N5obVRQzUv8MmgEi361sP8U8zbyuE5kWtDS1rUQusQIp/swr2+PxMdY44wpNRAhCao2fNtCsFy
	1iGMUkQUx35DNsCC01u96A4NIrko6Kqj9q9qvWLXSkZHOYsaUyDD1S+yDjnMeU/0mJWAx7JJIaK
	4wWvhWofHxgW9CIVzYr5q/TQTGZ47n5fYtp0KGOWGNH4ej4qcBnn85pX595i27GhzXtgPbKWZ1V
	WKhcbEb/ZSeRUE68M5pUW1tINJO4rvWHOtNMw13143xZ47PO8/9JqNyWwbr5KSKqWKWYlYeZ4fl
	BJix0FmMPj7V4YGKKxYgxgfRKiUGR5Yg0YkR8gfQ==
X-Received: by 2002:a17:902:d4cf:b0:2a1:e19:ff4 with SMTP id d9443c01a7336-2a870e3664dmr8581765ad.29.1769494251035;
        Mon, 26 Jan 2026 22:10:51 -0800 (PST)
Received: from lima-ubuntu.hz.ali.com ([47.246.98.220])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a802fb0262sm105384845ad.70.2026.01.26.22.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 22:10:50 -0800 (PST)
From: Qing Wang <wangqing7171@gmail.com>
To: ebiggers@kernel.org
Cc: jaegeuk@kernel.org,
	linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+d130f98b2c265fae5297@syzkaller.appspotmail.com,
	tytso@mit.edu,
	wangqing7171@gmail.com
Subject: Re: [PATCH] fscrypt: Fix uninit-value in ovl_fill_real
Date: Tue, 27 Jan 2026 14:10:44 +0800
Message-Id: <20260127061044.888379-1-wangqing7171@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260127034754.GA4470@sol>
References: <20260127034754.GA4470@sol>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1076-lists,linux-fscrypt=lfdr.de];
	FREEMAIL_CC(0.00)[kernel.org,vger.kernel.org,syzkaller.appspotmail.com,mit.edu,gmail.com];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[wangqing7171@gmail.com,linux-fscrypt@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[linux-fscrypt,d130f98b2c265fae5297];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 69A9C904BF
X-Rspamd-Action: no action

On Tue, 27 Jan 2026 at 11:47, Eric Biggers <ebiggers@kernel.org> wrote:
> This is an overlayfs patch, so please title it appropriately and use
> get_maintainer.pl to get the correct recipients.  You can leave
> linux-fscrypt@vger.kernel.org on Cc.

Thank you again for your guidance.

--
Best regards,
Qing

